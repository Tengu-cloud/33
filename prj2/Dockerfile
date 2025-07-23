FROM python:3.9-slim
WORKDIR /app
COPY http_serv.py /app/http_serv.py
RUN pip install prometheus_client
RUN pip install docker
EXPOSE 8080
CMD ["python", "/app/http_serv.py"]
