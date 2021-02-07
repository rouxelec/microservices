for i in $(seq 1 2); do
    echo $i
    curl $1
    sleep 1
    RESULT1=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"$2"}}' | jq -r '.Item.Version.S')
    echo $RESULT1
    RESULT2=$(aws dynamodb get-item --table-name Microservice --key '{"UserId":{"S":"api_version"}}' | jq -r '.Item.Version.S')
    echo $RESULT2
    if [ "$RESULT1" == "$RESULT2" ]
    then
        break;
    fi
done