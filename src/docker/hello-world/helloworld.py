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
        response = table.get_item(Key={'UserId': "Francois"})
    except Exception as e: 
        return str(e)
    return "Hello World v7!   "+response['Item']['UserId']+" : "+str(response['Item']['Score'])

@app.route("/healthcheck")
def healthcheck():
    return "HealthCheck!"
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)