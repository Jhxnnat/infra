FROM python:3.11-slim

LABEL maintainer="CTRL+Z"
LABEL description="Two route bare bones flask app"
LABEL version="0.1"

WORKDIR /app

COPY requirements.txt .
COPY app.py .

RUN pip install -r requirements.txt --no-cache-dir

RUN groupadd -r appgroup && useradd -r -g appgroup no-root

USER no-root

EXPOSE 5000

ENV FLASK_APP=app.py FLASK_RUN_HOST=5000

CMD python $FLASK_APP
# CMD python -m flask run --host=0.0.0.0 --port=$FLASK_RUN_HOST
