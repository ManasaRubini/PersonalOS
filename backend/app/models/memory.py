from sqlalchemy import Column, String, ForeignKey, Text, Float, DateTime
from app.models.user import Base
import uuid
import datetime

class MemoryBlock(Base):
    __tablename__ = "memories"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    category = Column(String, default="General Playbook")
    
    # 💾 OPTION B: Store vector math embeddings as a string of comma-separated floats
    embedding_vector = Column(Text, nullable=True)

class ChatSession(Base):
    __tablename__ = "chat_history"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    role = Column(String, nullable=False)  # "user" or "assistant"
    content = Column(Text, nullable=False)
    timestamp = Column(DateTime, default=datetime.datetime.utcnow)