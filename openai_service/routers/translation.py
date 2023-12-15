from fastapi import APIRouter
from langserve import add_routes

from openai_service.service.translation import translate


router = APIRouter(prefix="/translation")
add_routes(router, translate(), path="/text", enabled_endpoints=["invoke", "stream"])
# add_routes(
#     router, translate_gemini(), path="/gemini", enabled_endpoints=["invoke", "stream"]
# )
