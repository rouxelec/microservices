import boto3
import sys
from flask import Flask

app = Flask(__name__)
@app.route("/")
def hello():
    try:
      table = dynamodb.Table('GameScores')
      table.put_item(Item={"UserId":"Francois","Score":1})
    except:
        print("Unexpected error:", sys.exc_info()[0])
        return "Unexpected error:", sys.exc_info()[0]
    return "Hello World v3!"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)