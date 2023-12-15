from functools import lru_cache

from pydantic_settings import BaseSettings

from openai_service.config import prompts


class Settings(BaseSettings):
    openai_api_key: str
    translate_prompt: str = prompts.translate_prompt.replace("\n", "")
    gemini_prompt: str = prompts.translate_gemini.replace("\n", "")

    class Config:
        env_file = ".env"


@lru_cache(maxsize=1)
def get_settings():
    return Settings()  # type: ignore
