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


        response = table.update_item(
        Key={
            'UserId': "Francois"
        },
        UpdateExpression="set Score=Score+1, ScoreLambdaContainer=ScoreLambdaContainer+1
        ReturnValues="UPDATED_NEW"
        )

    except Exception as e: 
        table.put_item(Item={"UserId":"Francois","Score":1})
        response = table.get_item(Key={'UserId': "Francois"})
        
    result='Hello world from Lambda container!'+response["Item"]["UserId"]+' : '+str(response["Item"]["Score"])
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