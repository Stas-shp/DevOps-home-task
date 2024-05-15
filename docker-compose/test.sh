message="The Authorization header token is the epoch value of 01.01.2000 12:00:00 AM"

date_part="${message: -22}"
echo $date_part

epoch_value=$(date -u -d "$date_part" +"%s")
echo $epoch_value

json='{"Authorization": ""}'

# Assume epoch_value has been determined already

# Insert or update the timestamp in the existing JSON with epoch_value
updated_json=$(echo $json | jq --arg epoch "$epoch_value" '.Authorization = $epoch')
echo $updated_json