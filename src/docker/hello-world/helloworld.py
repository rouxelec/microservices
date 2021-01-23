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
        response = table.update_item(
        Key={
            "UserId": "Francois"
        },
        UpdateExpression="set Score = Score + :val, Score_lambda_ecs = Score_lambda_ecs + :val",
        ExpressionAttributeValues={
            ":val": int(1)
        },
        ReturnValues="UPDATED_NEW"
        )
        response = table.get_item(Key={'UserId': "Francois"})
    except Exception as e: 
        table.put_item(Item={"UserId":"Francois","Score":1,"Score_lambda":0,"Score_lambda_c":0,"Score_lambda_ecs":1})
        response = table.get_item(Key={'UserId': "Francois"})
    return "Hello World ecs version!   "+response['Item']['UserId']+" : "+str(response['Item']['Score'])

@app.route("/healthcheck")
def healthcheck():
    return "HealthCheck!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)