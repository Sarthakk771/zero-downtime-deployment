from flask import Flask
import os

app = Flask(__name__)

VERSION = os.getenv("VERSION", "1.0")
SERVER = os.getenv("SERVER", "server-1")


@app.route("/")
def home():
    return f"""
    <html>
        <head>
            <title>Zero Downtime Deployment</title>
        </head>
        <body>
            <h1>Automated Zero-Downtime Deployment Platform</h1>
            <h2>Version: {VERSION}</h2>
            <h3>Server: {SERVER}</h3>
            <p>Status: Running</p>
        </body>
    </html>
    """


@app.route("/health")
def health():
    if os.getenv("FAIL_HEALTH", "false").lower() == "true":
        return "Unhealthy", 500

    return "Healthy", 200


@app.route("/version")
def version():
    return {
        "version": VERSION,
        "server": SERVER
    }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)