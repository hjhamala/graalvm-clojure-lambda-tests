#!/usr/bin/env bash

set -eu

zip python.zip lambda.py
TIMESTAMP=$(date +%s)
echo $TIMESTAMP
aws s3 cp python.zip s3://$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')/$TIMESTAMP.zip

aws cloudformation deploy --stack-name=python-infra --template-file=templates/infra.yml --capabilities=CAPABILITY_IAM --parameter-overrides CodeTag=$TIMESTAMP.zip
aws cloudformation describe-stacks --stack-name=python-infra| jq -r '.Stacks[0].Outputs[0].OutputValue'

