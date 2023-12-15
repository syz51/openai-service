from langchain.chat_models import ChatOpenAI
from langchain.prompts.chat import ChatPromptTemplate

from openai_service.config.config import Settings, get_settings


def translate(settings: Settings = get_settings()):
    model = ChatOpenAI(
        model="gpt-3.5-turbo-1106", api_key=settings.openai_api_key, temperature=0.5
    )
    human_template = "{text}"

    prompt = ChatPromptTemplate.from_messages(
        [
            ("system", settings.translate_prompt),
            ("human", human_template),
        ]
    )

    return prompt | model
