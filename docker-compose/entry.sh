#!/bin/bash

cp -f /provider.tf provider.tf

terraform init
terraform apply --auto-approve

export AWS_ENDPOINT_URL=http://localstack:4566

output=$(awslocal apigateway get-rest-apis)
apigatewayid=$(echo $output | jq -r '.items[].id')
echo $apigatewayid

curl -X GET http://localstack:4566/restapis/$apigatewayid/test/_user_request_/

#Get the respose "The Authorization header token is the epoch value of 01.01.2000 12:00:00 AM"

message="The Authorization header token is the epoch value of 01.01.2000 12:00:00 AM"

date_part="${message: -22}"
echo $date_part

formatted_date=$(echo $date_part | awk -F'[. :]' '
{
  if ($6 == "PM" && $4 < 12) $4 += 12;
  if ($6 == "AM" && $4 == 12) $4 = "00";
  printf "%s-%02d-%02d %s:%s %s\n", $3, $2, $1, $4, $5, $7
}')

echo $formatted_date

epoch_value=$(date -u -d  "$formatted_date" +"%s")
echo $epoch_value

json='{"Authorization": ""}'

updated_json=$(echo $json | jq --arg epoch "$epoch_value" '.Authorization = $epoch')
echo $updated_json


curl -X POST http://localstack:4566/restapis/$apigatewayid/test/_user_request_/ \
  -H "Content-Type: application/json" \
  -d "$updated_json"

sleep infinity
