import boto3
from flask import Flask

app = Flask(__name__)
@app.route("/")
def hello():
    table = dynamodb.Table('GameScores')
    table.put_item(Item={"UserId":"Francois","Score":1})

    return "Hello World v2!"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)