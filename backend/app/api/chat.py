from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from pydantic import BaseModel
from sqlalchemy.orm import Session
from datetime import datetime
from app.models.user import get_db, User, SessionLocal
import json
from app.models.memory import MemoryBlock, ChatSession
from app.models.task import Task
from app.core.memory_engine import memory_engine
from app.core.style_engine import style_engine
from google import genai
from google.genai import types
from app.config import settings

router = APIRouter(prefix="/chat", tags=["Digital Twin Conversation Engine"])

class ExtractedMemory(BaseModel):
    should_remember: bool
    title: str
    content: str
    category: str # "Strategy", "Meeting", "Technical", "General"

def extract_and_save_memory(executive_id: str, query: str, twin_reply: str):
    client = genai.Client(api_key=settings.GEMINI_API_KEY)
    
    prompt = f"""
    Analyze the following recent conversation exchange between the user and their digital twin.
    Determine if any new, permanent fact, business strategy, meeting detail, technical parameter, 
    or piece of user information was revealed that is worth remembering long-term.
    
    User Query: "{query}"
    Digital Twin Response: "{twin_reply}"
    """
    
    try:
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt,
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
                response_schema=ExtractedMemory,
                system_instruction="You are a silent cognitive observer. Your goal is to extract valuable facts to store in the long-term knowledge base. If nothing of permanent value was shared, set should_remember to false. Otherwise, extract the facts cleanly and set should_remember to true."
            )
        )
        
        # Parse output
        data = json.loads(response.text)
        if data.get("should_remember"):
            db = SessionLocal()
            try:
                # Generate embedding
                vector = memory_engine.generate_embedding(data["content"])
                
                new_memory = MemoryBlock(
                    user_id=executive_id,
                    title=data["title"],
                    content=data["content"],
                    category=data["category"],
                    embedding_vector=json.dumps(vector)
                )
                db.add(new_memory)
                db.commit()
                print(f"✨ Auto-ingested new memory: {data['title']}")
            except Exception as e:
                db.rollback()
                print(f"❌ Failed to auto-ingest memory: {e}")
            finally:
                db.close()
    except Exception as e:
        print(f"❌ Error during background memory extraction: {e}")

class ChatRequest(BaseModel):
    query: str
    executive_id: str

@router.post("/query")
async def converse_with_twin(payload: ChatRequest, background_tasks: BackgroundTasks, db: Session = Depends(get_db)):
    try:
        user_profile = db.query(User).filter(User.id == payload.executive_id).first()
        if not user_profile:
            raise HTTPException(status_code=404, detail="Persona not found.")

        # 0. MEMORY RESET TRIGGER: "Forget everything"
        if "forget" in payload.query.lower() and "everything" in payload.query.lower():
            db.query(ChatSession).filter(ChatSession.user_id == payload.executive_id).delete()
            db.commit()
            return {
                "speaker_name": user_profile.full_name, 
                "digital_twin_response": "Understood. I have cleared our conversation history. My short-term context is now reset."
            }

        # 1. Proactive Task Audit
        now = datetime.utcnow()
        overdue_tasks = db.query(Task).filter(Task.user_id == payload.executive_id, Task.is_completed == False, Task.due_date <= now).all()
        task_alert = f"\n\n[URGENT REMINDER]: Overdue tasks: {', '.join([t.title for t in overdue_tasks])}" if overdue_tasks else ""

        # 2. Semantic Memory
        query_vector = memory_engine.generate_embedding(payload.query)
        memories = db.query(MemoryBlock).filter(MemoryBlock.user_id == payload.executive_id).all()
        context = "\n".join([m.content for m in memory_engine.rank_memories_semantically(query_vector, memories)]) if memories else "Maintain focus."

        # 3. Build Conversation
        history = db.query(ChatSession).filter(ChatSession.user_id == payload.executive_id).order_by(ChatSession.timestamp.desc()).limit(5).all()[::-1]
        
        system_instruction = f"You are {user_profile.full_name}, {user_profile.role}. Knowledge: {context}.{task_alert}"
        
        contents = []
        for log in history:
            role = "model" if log.role == "assistant" else "user"
            contents.append(types.Content(role=role, parts=[types.Part.from_text(text=log.content)]))
        contents.append(types.Content(role="user", parts=[types.Part.from_text(text=payload.query)]))

        # 4. Generate Response
        client = genai.Client(api_key=settings.GEMINI_API_KEY)
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=contents,
            config=types.GenerateContentConfig(
                system_instruction=system_instruction,
                temperature=0.4
            )
        )
        twin_reply = response.text

        # 5. Log
        db.add_all([ChatSession(user_id=payload.executive_id, role="user", content=payload.query), 
                    ChatSession(user_id=payload.executive_id, role="assistant", content=twin_reply)])
        db.commit()

        # 6. Extract Memory in background
        background_tasks.add_task(extract_and_save_memory, payload.executive_id, payload.query, twin_reply)

        return {"speaker_name": user_profile.full_name, "digital_twin_response": twin_reply}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))