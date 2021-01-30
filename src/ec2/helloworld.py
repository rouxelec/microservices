import boto3
import sys
from flask import Flask

from decimal import Decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return json.JSONEncoder.default(self, obj)

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
            "UserId": "ec2"
        },
        UpdateExpression="set Score = Score + :val",
        ExpressionAttributeValues={
            ":val": int(1)
        },
        ReturnValues="UPDATED_NEW"
        )
        response = table.get_item(Key={'UserId': "ec2"})
    except Exception as e: 
        table.put_item(Item={"UserId":"ec2","Score":1})
        response = table.get_item(Key={'UserId': "ec2"})
    return "Hello World old fashion ec2 version v1!   "+json.dumps(response["Item"], indent=4, sort_keys=True,cls=DecimalEncoder)

@app.route("/healthcheck")
def healthcheck():
    return "HealthCheck!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)