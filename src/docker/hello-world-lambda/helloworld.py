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
    version="11"
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb')
    try:
        table = dynamodb.Table('Microservice')
        response = table.update_item(
        Key={
            "UserId": "lambda_container"
        },
        UpdateExpression="set Score = Score + :val, Version = :ver",
        ExpressionAttributeValues={
            ":val": int(1),
            ":ver": version
        },
        ReturnValues="UPDATED_NEW"
        )
        response = table.get_item(Key={'UserId': "lambda_container"})
    except Exception as e: 
        table.put_item(Item={"UserId":"lambda_container","Score":1,"Version":"1"})
        response = table.get_item(Key={'UserId': "lambda_container"})
        
    result='Hello world from Lambda container v'+str(version)+'!   '+json.dumps(response["Item"], indent=4, sort_keys=True,cls=DecimalEncoder)
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