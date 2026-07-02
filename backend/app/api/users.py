from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.models.user import get_db, User

router = APIRouter(prefix="/users", tags=["Digital Twin Persona Registry"])

class UserCreate(BaseModel):
    full_name: str
    email: str
    role: str = "Executive"  # Executive, Tech_Lead, Strategist

@router.post("/register")
async def register_user(payload: UserCreate, db: Session = Depends(get_db)):
    try:
        # Check if email is already taken
        existing = db.query(User).filter(User.email == payload.email).first()
        if existing:
            raise HTTPException(status_code=400, detail="Profile email already registered.")
            
        new_user = User(
            full_name=payload.full_name,
            email=payload.email,
            role=payload.role
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        
        return {
            "status": "profile_created",
            "user_id": new_user.id,
            "full_name": new_user.full_name,
            "role": new_user.role
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get("/{user_id}")
async def get_user(user_id: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404)

    return {
        "user_id": user.id,
        "full_name": user.full_name,
        "email": user.email,
        "role": user.role
    }