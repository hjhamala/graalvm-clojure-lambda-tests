#!/usr/bin/env bash

mvn package

TIMESTAMP=$(date +%s)
echo $TIMESTAMP.jar > latest.tag
aws s3 cp target/hello-aws-1.0-SNAPSHOT.jar  s3://$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')/$TIMESTAMP.jar

aws cloudformation deploy --stack-name=jvm-infra --template-file=../lambda.yml --parameter-overrides \
    CodeTag=$TIMESTAMP.jar \
    Runtime=java8 \
    FunctionName=jvm-test \
    Handler=Lambda \
    Memory=1000
ENDPOINT=$(aws cloudformation describe-stacks --stack-name=jvm-infra| jq -r '.Stacks[0].Outputs[0].OutputValue')
echo "Test the api at $ENDPOINT"
echo $ENDPOINT > endpoint.uri