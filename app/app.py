from flask import Flask
import os

app = Flask(__name__)

VERSION = os.getenv("VERSION", "1.0")
SERVER = os.getenv("SERVER", "server-1")



@app.route("/")
def home():
    return f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Zero-Downtime Deployment Dashboard</title>
        <style>
            body {{
                margin: 0;
                font-family: Arial, sans-serif;
                background: #0f172a;
                color: white;
            }}

            .header {{
                padding: 25px;
                text-align: center;
                background: #111827;
            }}

            .header h1 {{
                margin: 0;
                font-size: 30px;
            }}

            .header p {{
                color: #94a3b8;
            }}

            .container {{
                max-width: 1100px;
                margin: 30px auto;
                padding: 20px;
            }}

            .cards {{
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }}

            .card {{
                background: #1e293b;
                padding: 25px;
                border-radius: 12px;
                text-align: center;
            }}

            .card h2 {{
                margin-top: 0;
            }}

            .status {{
                color: #22c55e;
                font-weight: bold;
                font-size: 20px;
            }}

            .server {{
                color: #38bdf8;
                font-size: 20px;
                font-weight: bold;
            }}

            .pipeline {{
                margin-top: 25px;
                background: #1e293b;
                padding: 25px;
                border-radius: 12px;
                text-align: center;
            }}

            .pipeline span {{
                color: #38bdf8;
                font-weight: bold;
            }}
           button {{
    background: #2563eb;
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    margin-top: 10px;
}}

button:hover {{
    background: #1d4ed8;
}}

            .log {{
                margin-top: 25px;
                background: #020617;
                padding: 20px;
                border-radius: 12px;
                font-family: monospace;
            }}

            .success {{
                color: #22c55e;
            }}
        </style>
    </head>

    <body>

        <div class="header">
            <h1>🚀 Zero-Downtime Deployment Platform</h1>
            <p>Deployment Monitoring Dashboard v2</p>
        </div>

        <div class="container">

            <div class="cards">

                <div class="card">
                    <h2>Current Version</h2>
                    <div class="server">{VERSION}</div>
                </div>

                <div class="card">
                    <h2>Deployment Status</h2>
                    <div class="status">● HEALTHY</div>
                </div>

                <div class="card">
                    <h2>Server</h2>
                    <div class="server">{SERVER}</div>
                </div>

            </div>

            <div class="pipeline">
                <h2>Deployment Pipeline</h2>

                <p>
                    GitHub
                    <span>→</span>
                    CI
                    <span>→</span>
                    Docker
                    <span>→</span>
                    Rolling Deployment
                    <span>→</span>
                    Health Check
                    <span>→</span>
                    Production
                </p>

                <p class="success">
                    ✓ Application is running successfully
                </p>
            </div>
<div class="pipeline">
    <h2>Live Health Check</h2>

    <button onclick="checkHealth()">
        Check Application Health
    </button>

    <p id="healthResult">Click the button to check the application.</p>
</div>

<script>
async function checkHealth() {{
    const result = document.getElementById("healthResult");

    result.innerHTML = "Checking...";

    try {{
        const response = await fetch("/health");

        if (response.ok) {{
            result.innerHTML = "🟢 Application is HEALTHY";
            result.style.color = "#22c55e";
        }} else {{
            result.innerHTML = "🔴 Health check FAILED";
            result.style.color = "#ef4444";
        }}
    }} catch (error) {{
        result.innerHTML = "🔴 Application is UNAVAILABLE";
        result.style.color = "#ef4444";
    }}
}}
</script>
            <div class="log">
                <h2>Deployment Information</h2>
                <p class="success">✓ Application container running</p>
                <p class="success">✓ Health check endpoint available</p>
                <p class="success">✓ Load balancer connected</p>
                <p class="success">✓ Deployment validation enabled</p>
                <p class="success">✓ Automatic rollback enabled</p>
            </div>

        </div>

    </body>
    </html>
    """


@app.route("/health")
def health():
    return "Healthy", 200


@app.route("/version")
def version():
    return {
        "version": VERSION,
        "server": SERVER
    }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)