RESULT2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"api_version"}}' --region us-east-1 | jq -r '.Item.Version.S')
for i in $(seq 1 2000); do
    curl $1
    sleep 1
    RESULT1=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"ecs"}}' --region us-east-1 | jq -r '.Item.Version.S')
    if  [ "$RESULT1" = "$RESULT2" ]
    then
        echo "TEST SUCCESS ECS DEPLOYED VERSION $RESULT1"
        DATE=$(date +%s)
        echo "{\"id\":{\"S\":\"ecs\"},\"when\":{\"S\":\"stop\"},\"time\":{\"S\":\"${DATE}\"}}" > date_ecs.json
        aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date_ecs.json
        exit 0
    fi
done
exit 1