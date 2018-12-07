#!/usr/bin/env bash
set -eu
aws lambda update-function-code --function-name python-test --s3-bucket=graal-s3-bucket-infrapipelinebucket-1mjccq5agtv9u --s3-key=1544111274.zip >> /dev/null

sleep 0.1
curl -s -o /dev/null -w "%{http_code},%{time_total}\n"  https://azqlj710cc.execute-api.eu-west-1.amazonaws.com/dev/helloWorld >> cold.txt

for i in {1..5}; do curl -s -o /dev/null -w "%{http_code},%{time_total}\n"  https://azqlj710cc.execute-api.eu-west-1.amazonaws.com/dev/helloWorld >> warm.txt; done
