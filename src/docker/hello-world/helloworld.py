import boto3
import sys
from flask import Flask

app = Flask(__name__)
dynamodb=None
@app.route("/")
def hello():
    return "Hello World v3!"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)