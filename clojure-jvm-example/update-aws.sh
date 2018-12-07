#!/usr/bin/env bash

set -eu
lein uberjar

TIMESTAMP=$(date +%s)
echo $TIMESTAMP.jar > latest.tag
aws s3 cp target//uberjar/server.jar s3://$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')/$TIMESTAMP.jar

aws cloudformation deploy --stack-name=clojure-infra --template-file=../lambda.yml --parameter-overrides \
    CodeTag=$TIMESTAMP.jar \
    Runtime=java8 \
    FunctionName=clojure-test \
    Handler=Lambda \
    Memory=1000

ENDPOINT=$(aws cloudformation describe-stacks --stack-name=clojure-infra| jq -r '.Stacks[0].Outputs[0].OutputValue')
echo "Test the api at $ENDPOINT"
echo $ENDPOINT > endpoint.uri