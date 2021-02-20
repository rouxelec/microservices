#!/bin/bash
EC2_START=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"ec2"},"when":{"S":"start"}}' --region us-east-1 | jq -r '.Item.time.S')
EC2_STOP=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"ec2"},"when":{"S":"stop"}}' --region us-east-1 | jq -r '.Item.time.S')
EC2_TIME="$(($EC2_STOP-$EC2_START))"
echo EC2 deployed in $EC2_TIME SECONDS

ECS_START=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"ecs"},"when":{"S":"start"}}' --region us-east-1 | jq -r '.Item.time.S')
ECS_STOP=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"ecs"},"when":{"S":"stop"}}' --region us-east-1 | jq -r '.Item.time.S')
ECS_TIME="$(($ECS_STOP-$ECS_START))"
echo ECS deployed in $ECS_TIME SECONDS

LA_START=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"la"},"when":{"S":"start"}}' --region us-east-1 | jq -r '.Item.time.S')
LA_STOP=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"la"},"when":{"S":"stop"}}' --region us-east-1 | jq -r '.Item.time.S')
LA_TIME="$(($LA_STOP-$LA_START))"
echo Classic Lambda deployed in $LA_TIME SECONDS

LC_START=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"lc"},"when":{"S":"start"}}' --region us-east-1 | jq -r '.Item.time.S')
LC_STOP=$(aws dynamodb get-item --table-name Deployment --key '{"id":{"S":"lc"},"when":{"S":"stop"}}' --region us-east-1 | jq -r '.Item.time.S')
LCO_TIME="$(($LC_STOP-$LC_START))"
echo Lambda Container deployed in $LCO_TIME SECONDS