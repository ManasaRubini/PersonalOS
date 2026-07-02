from sqlalchemy import create_engine, Column, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import uuid
from app.config import settings

# 🛠️ Smart connection engine selector
if "sqlite" in settings.DATABASE_URL:
    # SQLite requires 'connect_args' to safely handle multiple background threads in FastAPI
    engine = create_engine(settings.DATABASE_URL, connect_args={"check_same_thread": False})
else:
    engine = create_engine(settings.DATABASE_URL.replace("postgresql://", "postgresql+psycopg://"))

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

class User(Base):
    __tablename__ = "users"

    # Changed from UUID columns to simple Strings for lightweight SQLite compatibility
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    full_name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    role = Column(String, default="Mentee")
    mentor_id = Column(String, ForeignKey("users.id"), nullable=True)