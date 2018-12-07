#!/usr/bin/env bash
set -eu
ENDPOINT=$(cat endpoint.uri)
TAG=$(cat latest.tag)
BUCKET=$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')

for i in {1..1000}

do
aws lambda update-function-code --function-name jvm-test --s3-bucket=$BUCKET --s3-key=$TAG >> /dev/null
sleep 0.1
curl -s -o /dev/null -w "%{http_code},%{time_total}\n"  $ENDPOINT >> cold.txt
    for i in {1..5}
    do
        curl -s -o /dev/null -w "%{http_code},%{time_total}\n"  $ENDPOINT >> warm.txt
        done
done
