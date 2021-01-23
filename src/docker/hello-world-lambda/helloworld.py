import json
import boto3

def lambda_handler(event, context):
    dynamodb=None
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb')
    try:
        table = dynamodb.Table('GameScores')
        response = table.update_item(
        Key={
            "UserId": "Francois"
        },
        UpdateExpression="set Score = Score + :val, Score_container = Score_container + :val",
        ExpressionAttributeValues={
            ":val": int(1)
        },
        ReturnValues="UPDATED_NEW"
        )
        response = table.get_item(Key={'UserId': "Francois"})
    except Exception as e: 
        table.put_item(Item={"UserId":"Francois","Score":1,"Score_lambda":0,"Score_container":1,"Score_lambda_ecs":0})
        response = table.get_item(Key={'UserId': "Francois"})
        
    result='Hello world from Lambda container :) !'+response["Item"]["UserId"]+' : '+str(response["Item"]["Score"])
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