RESULT2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"api_version"}}' --region us-east-1 | jq -r '.Item.Version.S')
for i in $(seq 1 5000); do
    curl $1
    sleep 1
    RESULT1=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"lambda_container"}}' --region us-east-1  | jq -r '.Item.Version.S')
    if [ "$RESULT1" = "$RESULT2" ]
    then
        echo "TEST SUCCESS Lambda Container DEPLOYED VERSION $RESULT1"
        DATE=$(date +%s)
        echo "{\"id\":{\"S\":\"lc\"},\"when\":{\"S\":\"stop\"},\"time\":{\"S\":\"${DATE}\"}}" > date_lc.json
        aws dynamodb put-item --table-name Deployment --region us-east-1 --item file://date_lc.json
        exit 0
    fi
done
exit 1