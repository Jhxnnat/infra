FROM python:3.11-slim

LABEL org.opencontainers.image.title="flask_example_ctrlz"
LABEL description="Flask app example"
LABEL version="1.0.0"
LABEL author="CTRL+Z"
LABEL source="https://github.com/Jhxnnat/infra/tree/main/docker-challenges/e4"

WORKDIR /app

COPY requirements.txt .
COPY app.py .

RUN pip install -r requirements.txt --no-cache-dir

RUN groupadd -r appgroup && useradd -r -g appgroup no-root

USER no-root

EXPOSE 5000

ENV FLASK_RUN_HOST=5000

HEALTHCHECK --interval=5m --timeout=5s --start-period=10s --retries=3 \
	CMD curl -f http://localhost:$FLASK_RUN_HOST/health || exit 1

CMD ["python", "app.py"]

