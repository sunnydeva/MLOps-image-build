FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
        && apt-get install -y curl build-essential gcc \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry

RUN poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock* /app/

RUN poetry install --no-root --no-interaction --no-ansi