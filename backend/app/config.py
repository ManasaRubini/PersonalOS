import os
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    PROJECT_NAME: str = "Digital Twin Corporate Framework"
    DATABASE_URL: str = "sqlite:///./dev_twin.db"
    SECRET_KEY: str = "fallback_secret_key"
    GEMINI_API_KEY: str = ""

    # This tells Pydantic to look for the .env file in the current directory
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore"
    )

settings = Settings()