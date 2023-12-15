from fastapi import APIRouter
from langserve import add_routes

from openai_service.service.translation import translate


router = APIRouter(prefix="/translation")

add_routes(router, translate(), path="/text")
