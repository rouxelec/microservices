RESULT2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"api_version"}}' | jq -r '.Item.Version.S')
for i in $(seq 1 50); do
    curl $1
    sleep 1
    RESULT1=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"classic_lambda"}}' | jq -r '.Item.Version.S')
    if [ "$RESULT1" == "$RESULT2" ]
    then
        echo "TEST SUCCESS"
        exit 0
    fi
done
exit 1