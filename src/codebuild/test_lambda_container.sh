for i in $(seq 1 2000); do
    curl $1
    RESULT1=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"lambda_container"}}' | jq -r '.Item.Version.S')
    echo result1:
    echo $RESULT1
    RESULT2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"api_version"}}' | jq -r '.Item.Version.S')
    echo result2:
    echo $RESULT2
    if [ "$RESULT1" == "$RESULT2" ]
    then
        echo "TEST SUCCESS"
        exit 0
    fi
done
exit 1