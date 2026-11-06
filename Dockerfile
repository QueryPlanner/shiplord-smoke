FROM python:3.12-slim@sha256:6b25cbe6577518889d553cdd5a5da97d259348d8f6e45b527dd731caaba27a07
WORKDIR /app
COPY server.py release.txt ./
USER 10001:10001
EXPOSE 8080
CMD ["python", "-u", "/app/server.py"]
