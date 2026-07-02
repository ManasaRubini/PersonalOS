from fastapi import APIRouter, Depends, BackgroundTasks
from sqlalchemy.orm import Session
from app.models.user import get_db
from app.models.task import Task
from pydantic import BaseModel
import datetime

router = APIRouter(prefix="/tasks", tags=["Task Management"])

class TaskCreate(BaseModel):
    executive_id: str
    title: str
    description: str
    due_minutes_from_now: int

@router.post("/add")
async def create_task(payload: TaskCreate, db: Session = Depends(get_db)):
    due_time = datetime.datetime.utcnow() + datetime.timedelta(minutes=payload.due_minutes_from_now)
    new_task = Task(
        user_id=payload.executive_id,
        title=payload.title,
        description=payload.description,
        due_date=due_time
    )
    db.add(new_task)
    db.commit()
    return {"status": "task_scheduled", "task_id": new_task.id}