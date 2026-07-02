from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings


# 1. Import all your routers
from app.api.chat import router as chat_router
from app.api.memories import router as memory_router
from app.api.users import router as user_router
from app.api.tasks import router as task_router # Import the new task router
from app.api.reset import router as reset_router # Import the reset router
from app.api.dashboard import router as dashboard_router
# 2. Import ALL your models before Base.metadata.create_all
# This ensures SQLAlchemy sees the 'Task', 'User', and 'Memory' tables
from app.models.user import Base, engine, User
from app.models.memory import MemoryBlock, ChatSession
from app.models.task import Task 

# Create the database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.PROJECT_NAME, version="1.0.0")

# Middleware for browser connectivity
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 3. Register your routers
app.include_router(chat_router)
app.include_router(memory_router)
app.include_router(user_router)
app.include_router(task_router) 
app.include_router(reset_router)# Register the task router
app.include_router(dashboard_router)

@app.get("/")
async def root():
    return {"status": "online", "system": "Digital Twin Cognitive Framework"}