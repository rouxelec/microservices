import boto3
import sys
from flask import Flask

app = Flask(__name__)
dynamodb=None
@app.route("/")
def hello():
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb')
    try:
      table = dynamodb.Table('GameScores')
      table.put_item(Item={"UserId":"Francois","Score":10})
    except:
        print("Unexpected error:", sys.exc_info()[0])
    return "Hello World v3!"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)