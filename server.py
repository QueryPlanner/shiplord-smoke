import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


class SmokeHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/ready":
            self.respond(200, "ready")
        elif self.path == "/":
            self.respond(200, Path("/app/release.txt").read_text().strip())
        else:
            self.respond(404, "missing")

    def respond(self, status, text):
        body = (text + "\n").encode()
        self.send_response(status)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    address = (os.environ.get("HOST", "0.0.0.0"), int(os.environ.get("PORT", "8080")))
    ThreadingHTTPServer(address, SmokeHandler).serve_forever()
