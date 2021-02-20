#!/bin/bash
DATE=$(date +%s)
sed -i "s|version=\"${1}\"|version=\"${2}\"|g" ../docker/hello-world/helloworld.py
sed -i "s|version=\"${1}\"|version=\"${2}\"|g" ../docker/hello-world-lambda/helloworld.py
sed -i "s|version=\"${1}\"|version=\"${2}\"|g" ../ec2/helloworld.py
sed -i "s|version=\"${1}\"|version=\"${2}\"|g" ../lambda/helloworld.py
git add ../docker/hello-world-lambda/helloworld.py ../docker/hello-world/helloworld.py ../ec2/helloworld.py  ../lambda/helloworld.py
git commit -m"benchmark test"
git push
echo "{\"UserId\":{\"S\":\"api_version\"},\"Version\":{\"S\":\"${2}\"}}" > version.json
aws dynamodb put-item --table-name Microservice --region us-east-1 --item file://version.json

echo "{\"id\":{\"S\":\"ecs\"},\"when\":{\"S\":\"start\"},\"time\":{\"S\":\"${DATE}\"}}" > date.json
aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date.json
echo "{\"id\":{\"S\":\"ec2\"},\"when\":{\"S\":\"start\"},\"time\":{\"S\":\"${DATE}\"}}" > date.json
aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date.json
echo "{\"id\":{\"S\":\"la\"},\"when\":{\"S\":\"start\"},\"time\":{\"S\":\"${DATE}\"}}" > date.json
aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date.json
echo "{\"id\":{\"S\":\"lc\"},\"when\":{\"S\":\"start\"},\"time\":{\"S\":\"${DATE}\"}}" > date.json
aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date.json
ALB_URL=$(aws ssm get-parameter --name "alb_url" --region us-east-1| jq -r '.Parameter.Value')

QUERY_STRING="?target=lc"
URL="$ALB_URL$QUERY_STRING"
echo $URL
sh test_lambda_container.sh $URL

QUERY_STRING="?target=ecs"
URL="$ALB_URL$QUERY_STRING"
echo $URL
sh test_ecs.sh $URL

QUERY_STRING="?target=ec2"
URL="$ALB_URL$QUERY_STRING"
echo $URL
sh test_ec2.sh $URL

QUERY_STRING="?target=la"
URL="$ALB_URL$QUERY_STRING"
echo $URL
sh test_classic_lambda.sh $URL