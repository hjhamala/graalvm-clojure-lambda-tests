#!/usr/bin/env bash

set -eu

zip python.zip lambda.py
TIMESTAMP=$(date +%s)
echo $TIMESTAMP.zip > latest.tag
aws s3 cp python.zip s3://$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')/$TIMESTAMP.zip

aws cloudformation deploy --stack-name=python-infra --template-file=../lambda.yml --parameter-overrides \
    CodeTag=$TIMESTAMP.zip \
    Runtime=python3.7 \
    FunctionName=python-test \
    Handler=lambda.handler \
    Memory=1000

ENDPOINT=$(aws cloudformation describe-stacks --stack-name=python-infra| jq -r '.Stacks[0].Outputs[0].OutputValue')
echo "Test the api at $ENDPOINT"
echo $ENDPOINT > endpoint.uri

