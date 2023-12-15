from fastapi import FastAPI

from openai_service.routers.translation import router

app = FastAPI(openapi_url=None)

app.include_router(router)
