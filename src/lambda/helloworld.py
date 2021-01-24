import json
import boto3

from decimal import Decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return json.JSONEncoder.default(self, obj)

def lambda_handler(event, context):
    dynamodb=None
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb')
    try:
        table = dynamodb.Table('GameScores')
        response = table.update_item(
        Key={
            "UserId": "classic_lambda"
        },
        UpdateExpression="set Score = Score + :val",
        ExpressionAttributeValues={
            ":val": int(1)
        },
        ReturnValues="UPDATED_NEW"
        )
        response = table.get_item(Key={'UserId': "classic_lambda"})
    except Exception as e: 
        table.put_item(Item={"UserId":"classic_lambda","Score":1})
        response = table.get_item(Key={'UserId': "classic_lambda"})
        
    result='Hello world from classic Lambda!'+json.dumps(response["Item"], indent=4, sort_keys=True,cls=DecimalEncoder)
    response = {
    "statusCode": 200,
    "statusDescription": "200 OK",
    "isBase64Encoded": False,
    "headers": {
    "Content-Type": "text/html; charset=utf-8"
    }
    }
    
    response['body'] = result
    return response