from flask import Flask, jsonify, render_template, request, redirect, url_for
import psycopg2
from redis import Redis
import os

app = Flask("app")
redis = Redis(host='redis', port=6379)

FLASK_PORT = os.environ.get('FLASK_PORT')
if not FLASK_PORT:
    FLASK_PORT = 5000
else:
    FLASK_PORT = int(FLASK_PORT)

def get_db_connection():
    conn = psycopg2.connect(
        host='db',
        database=os.environ.get('DB_NAME'),
        user=os.environ.get('DB_USERNAME'),
        password=os.environ.get('DB_PASSWORD')
    )
    return conn

# contador de visitas con Redis
@app.route('/', methods=['GET'])
def index():
    redis.incr('hits')
    counter = str(redis.get('hits'),'utf-8')
    return render_template('index.html', visits=counter)

# GET/productos: Lista productos desde PostgreSQL
@app.route("/products")
def products():
    redis.incr('hits')
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM products;')
    products = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('products.html', products=products)

# GET/health: Estado de conectividad con Redis y DB
@app.route("/health")
def health():
    status = {
        "redis": "available",
        "db": "available"
    }
    
    try: redis.incr('hits')
    except: status["redis"] = "unavailable"

    try: conn = get_db_connection()
    except: status["db"] = "unavailable"

    return render_template('health.html', status=status)
    

if __name__ == "__main__":
    print("Stating Flask App...")
    app.run(host="0.0.0.0", port=FLASK_PORT, debug=True)
