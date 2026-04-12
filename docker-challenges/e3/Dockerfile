# -- Pyton FLask App --
FROM python:3.11-slim

LABEL maintainer="CTRL+Z"
LABEL description="Backend Flask API connected to redis and postgresql db"
LABEL version="0.1"

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir
COPY app.py .
COPY templates templates

RUN groupadd -r appgroup && useradd -r -g appgroup flask
USER flask

EXPOSE 5000
ENV FLASK_RUN_HOST=5000

CMD python app.py

