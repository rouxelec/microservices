for i in $(seq 1 2000); do
    curl $1
    sleep 1
    RESULT1=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"classic_lambda"}}' --region us-east-1  | jq -r '.Item.Version.S')
    echo result1:
    echo $RESULT1
    RESULT2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"api_version"}}' --region us-east-1 | jq -r '.Item.Version.S')
    echo result2:
    echo $RESULT2
    if [ "$RESULT1" = "$RESULT2" ]
    then
        echo "TEST SUCCESS"
        DATE=$(date +%s)
        echo "{\"id\":{\"S\":\"la\"},\"when\":{\"S\":\"start\"},\"time\":{\"S\":\"${DATE}\"}}" > date_la.json
        aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date_la.json
        exit 0
    fi
done
exit 1