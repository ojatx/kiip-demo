from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def read_root():
    return """
    <html>
        <head><title>Kiip Demo App</title></head>
        <body>
            <h1>Welcome to Kiip Demo</h1>
            <p id="status">System Status: Operational</p>
        </body>
    </html>
    """
