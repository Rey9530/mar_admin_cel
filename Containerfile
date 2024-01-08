FROM docker.io/tiangolo/uvicorn-gunicorn:python3.9

LABEL maintainer="Douglas Guzman <drguzman@cel.gob.sv>"

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY ./app /app