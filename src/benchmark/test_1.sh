#!/bin/bash
ALB_URL=$(aws ssm get-parameter --name "alb_url" --region us-east-1| jq -r '.Parameter.Value')

QUERY_STRING="?target=lc"
URL_LC="$ALB_URL$QUERY_STRING"

QUERY_STRING="?target=ecs"
URL_ECS="$ALB_URL$QUERY_STRING"

QUERY_STRING="?target=ec2"
URL_EC2="$ALB_URL$QUERY_STRING"

QUERY_STRING="?target=la"
URL_LA="$ALB_URL$QUERY_STRING"

SCORE_BEFORE_EC2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"ec2"}}' --region us-east-1  | jq -r '.Item.Score.N')
SCORE_BEFORE_ECS=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"ecs"}}' --region us-east-1  | jq -r '.Item.Score.N')
SCORE_BEFORE_LC=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"lambda_container"}}' --region us-east-1  | jq -r '.Item.Score.N')
SCORE_BEFORE_LA=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"classic_lambda"}}' --region us-east-1  | jq -r '.Item.Score.N')
SLEEP_TIME=0.5
for i in $(seq 1 1000); do
    curl $URL_EC2 &
    curl $URL_LC &
    curl $URL_ECS &
    curl $URL_LA &
    sleep $SLEEP_TIME
done
SLEEP_TIME=0.3
for i in $(seq 1 1000); do
    curl $URL_EC2 &
    curl $URL_LC &
    curl $URL_ECS &
    curl $URL_LA &
    sleep $SLEEP_TIME
done
SLEEP_TIME=0.2
for i in $(seq 1 1000); do
    curl $URL_EC2 &
    curl $URL_LC &
    curl $URL_ECS &
    curl $URL_LA &
    sleep $SLEEP_TIME
done
SLEEP_TIME=0.1
for i in $(seq 1 1000); do
    curl $URL_EC2 &
    curl $URL_LC &
    curl $URL_ECS &
    curl $URL_LA &
    sleep $SLEEP_TIME
done
sleep 60
SCORE_AFTER_EC2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"ec2"}}' --region us-east-1  | jq -r '.Item.Score.N')
SCORE_AFTER_ECS=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"ecs"}}' --region us-east-1  | jq -r '.Item.Score.N')
SCORE_AFTER_LC=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"lambda_container"}}' --region us-east-1  | jq -r '.Item.Score.N')
SCORE_AFTER_LA=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"classic_lambda"}}' --region us-east-1  | jq -r '.Item.Score.N')
EC2_HIT="$(($SCORE_AFTER_EC2-$SCORE_BEFORE_EC2))"
echo EC2 hit $EC2_HIT TIMES
ECS_HIT="$(($SCORE_AFTER_ECS-$SCORE_BEFORE_ECS))"
echo ECS hit $ECS_HIT TIMES
LA_HIT="$(($SCORE_AFTER_LA-$SCORE_BEFORE_LA))"
echo LA hit $LA_HIT TIMES
LC_HIT="$(($SCORE_AFTER_LC-$SCORE_BEFORE_LC))"
echo LC hit $LC_HIT TIMES

exit 0