from flask import Flask
from collections.abc import MutableMapping

app = Flask(__name__)

@app.route('/')
def index():
    return "Hello world!"

app.run(host='0.0.0.0', port=80)
