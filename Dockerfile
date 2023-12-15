# Build a virtualenv using the appropriate Debian release
# * Install python3-venv for the built-in Python3 venv module (not installed by default)
# * Install gcc libpython3-dev to compile C Python modules
# * In the virtualenv: Update pip setuputils and wheel to support building new packages
FROM debian:12-slim AS build
WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    POETRY_HOME=/app/poetry \
    POETRY_VERSION=1.7.1
RUN --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes gcc libpython3-dev curl ca-certificates python3-minimal && \
    curl -sSL https://install.python-poetry.org | python3 -

# Build the virtualenv as a separate step: Only re-execute this step when requirements.txt changes
FROM build AS build-venv
COPY pyproject.toml poetry.lock ./
RUN --mount=type=cache,target=$POETRY_CACHE_DIR $POETRY_HOME/bin/poetry install --no-root

# Copy the virtualenv into a distroless image
FROM gcr.io/distroless/python3-debian12:nonroot
WORKDIR /app
COPY --from=build-venv /app/.venv /venv
COPY openai_service ./openai_service

EXPOSE 8000

ENTRYPOINT [ "/venv/bin/python3", "/venv/bin/uvicorn", "openai_service.main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8000" ]
