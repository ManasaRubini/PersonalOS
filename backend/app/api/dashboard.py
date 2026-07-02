from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.models.user import get_db
from app.models.task import Task
from app.models.memory import MemoryBlock, ChatSession

router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"],
)


@router.get("/{executive_id}")
async def dashboard(
    executive_id: str,
    db: Session = Depends(get_db),
):

    task_count = db.query(Task).filter(
        Task.user_id == executive_id
    ).count()

    completed_tasks = db.query(Task).filter(
        Task.user_id == executive_id,
        Task.is_completed == True,
    ).count()

    overdue_tasks = db.query(Task).filter(
        Task.user_id == executive_id,
        Task.is_completed == False,
    ).count()

    memory_count = db.query(MemoryBlock).filter(
        MemoryBlock.user_id == executive_id
    ).count()

    chat_count = db.query(ChatSession).filter(
        ChatSession.user_id == executive_id
    ).count()

    return {

        "tasks": task_count,

        "completed": completed_tasks,

        "pending": overdue_tasks,

        "memories": memory_count,

        "conversations": chat_count,
    }