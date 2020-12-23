import json
import boto3

def lambda_handler(event, context):
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
    result='Hello world from Lambda!'+response["Item"]["UserId"]+' : '+str(response["Item"]["Score"])
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