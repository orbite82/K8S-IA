from flask import Flask
import os
import psycopg2

app = Flask(__name__)

@app.route('/')
def home():
    db_host = os.getenv("DB_HOST", "postgres-svc")
    db_port = os.getenv("DB_PORT", 5432)
    return f"Aplicação rodando! Conectando ao banco em {db_host}:{db_port}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)