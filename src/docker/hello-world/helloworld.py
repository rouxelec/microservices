import boto3
import sys
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    dynamodb=None
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb')
    try:
        table = dynamodb.Table('GameScores')
        response = table.get_item(Key={'UserId': "Francois"})
        score=response['Item'].get('Score')+1
        print(score)
        table.put_item(Item={"UserId":"Francois","Score":score})
    except:
        print("Unexpected error:", sys.exc_info()[0])
        return "Unexpected error:"
    return "Hello World v6!"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)