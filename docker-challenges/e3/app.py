from flask import Flask, jsonify, render_template, request, redirect, url_for
from redis import Redis
import os

app = Flask("app")
redis = Redis(host='redis', port=6379)

FLASK_PORT = os.environ.get('FLASK_PORT')
if not FLASK_PORT:
    FLASK_PORT = 5000
else:
    FLASK_PORT = int(FLASK_PORT)

# contador de visitas con Redis
@app.route('/', methods=['GET'])
def main():
    redis.incr('hits')
    counter = str(redis.get('hits'),'utf-8')
    return render_template('index.html', visits=counter)

# GET/health: Estado de conectividad con Redis y DB
# @app.route("/health")
# def health():
#     pass

# GET/productos: Lista productos desde PostgreSQL
# @app.route("/products")
# def products():
#     pass

if __name__ == "__main__":
    print("Stating Flask App...")
    app.run(host="0.0.0.0", port=FLASK_PORT, debug=True)
