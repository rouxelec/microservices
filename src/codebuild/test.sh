#!/bin/bash
for i in $(seq 1 60); do
    echo $i
    curl $1
    sleep(1)
    RESULT=$(aws dynamodb get-item --table-name Deployment --key '{"UserId":{"S":"ec2"}}')
    echo $RESULT
done