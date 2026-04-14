from flask import Flask, jsonify
import socket
import os
import platform
from datetime import datetime

app = Flask(__name__)

START_TIME = datetime.now()

FLASK_RUN_HOST = os.environ.get("FLASK_RUN_HOST")
if not FLASK_RUN_HOST:
    FLASK_RUN_HOST = 5000
else:
    FLASK_RUN_HOST = int(FLASK_RUN_HOST)

@app.route("/")
def host_info():
    info = {
        "hostname": socket.gethostname(),
        "ip_address": socket.gethostbyname(socket.gethostname()),
        "os": platform.system(),
        "os_version": platform.version(),
        "architecture": platform.machine(),
        "python_version": platform.python_version(),
        "pid": os.getpid(),
        "timestamp": datetime.now().isoformat() + "Z",
    }
    return jsonify(info), 200

@app.route("/health")
def health():
    uptime_seconds = (datetime.now() - START_TIME).total_seconds()
    status = {
        "status": "healthy",
        "uptime_seconds": round(uptime_seconds, 2),
        "started_at": START_TIME.isoformat() + "Z",
        "checked_at": datetime.now().isoformat() + "Z",
    }
    return jsonify(status), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=FLASK_RUN_HOST, debug=False)
