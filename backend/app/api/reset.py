from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models.user import get_db
from app.models.memory import ChatSession

router = APIRouter(prefix="/reset", tags=["Digital Twin Management"])

@router.delete("/history/{executive_id}")
async def clear_chat_history(executive_id: str, db: Session = Depends(get_db)):
    """Wipes the short-term conversation context for a specific persona."""
    try:
        # Delete all session logs for this user
        db.query(ChatSession).filter(ChatSession.user_id == executive_id).delete()
        db.commit()
        return {"status": "success", "message": f"Conversation history cleared for {executive_id}"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))