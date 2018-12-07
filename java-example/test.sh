#!/usr/bin/env bash
set -eu
aws lambda update-function-code --function-name jvm-test --zip-file fileb://target/hello-aws-1.0-SNAPSHOT.jar >> /dev/null
sleep 0.1
curl -s -o /dev/null -w "%{http_code},%{time_total}\n"  https://ylk1jg4mt1.execute-api.eu-west-1.amazonaws.com/dev/helloWorld >> cold.txt
for i in {1..5}; do curl -s -o /dev/null -w "%{http_code},%{time_total}\n"  https://ylk1jg4mt1.execute-api.eu-west-1.amazonaws.com/dev/helloWorld >> warm.txt; done
