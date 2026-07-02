import json
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.models.user import get_db
from app.models.memory import MemoryBlock
from app.core.memory_engine import memory_engine

router = APIRouter(prefix="/memory", tags=["Digital Twin Knowledge Ingestion"])

class MemoryCreate(BaseModel):
    executive_id: str
    title: str
    content: str
    category: str = "Strategy"

@router.post("/add")
async def add_knowledge_to_twin(payload: MemoryCreate, db: Session = Depends(get_db)):
    try:
        # Generate the embedding vector live
        vector = memory_engine.generate_embedding(payload.content)
        
        new_memory = MemoryBlock(
            user_id=payload.executive_id,
            title=payload.title,
            content=payload.content,
            category=payload.category,
            embedding_vector=json.dumps(vector) # Save array safely as plain text text strings
        )
        db.add(new_memory)
        db.commit()
        db.refresh(new_memory)
        return {"status": "success", "memory_id": new_memory.id}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))