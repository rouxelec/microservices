import boto3
import json

def hello(dynamodb=None):
    response=None
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
        return "Unexpected error:", sys.exc_info()[0]
    result=str(response)
    print(result)
    return "Hello World v6!   "+response['Item']['UserId']+" : "+str(response['Item']['Score'])
if __name__ == "__main__":
    hello()