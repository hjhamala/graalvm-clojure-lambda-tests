#!/usr/bin/env bash

mvn package

TIMESTAMP=$(date +%s)
aws s3 cp target/hello-aws-1.0-SNAPSHOT.jar  s3://$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')/$TIMESTAMP.jar

aws cloudformation deploy --stack-name=jvm-infra --template-file=templates/infra.yml --capabilities=CAPABILITY_IAM --parameter-overrides CodeTag=$TIMESTAMP.jar
aws cloudformation describe-stacks --stack-name=jvm-infra| jq -r '.Stacks[0].Outputs[0].OutputValue'

curl -so /dev/null -w '%{time_total}\n' https://ylk1jg4mt1.execute-api.eu-west-1.amazonaws.com/dev/helloWorld >> cold.txt

for i in {1..50}; do curl -so /dev/null -w '%{time_total}\n' https://ylk1jg4mt1.execute-api.eu-west-1.amazonaws.com/dev/helloWorld >> warm.txt; done



echo "Checking build container presence"
docker inspect --type=image build-cont:latest > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Container image already exits"
else
    echo "Creating container image"
    docker build -t graal-build-img .
fi
echo "Building Clojure uberjar"
lein uberjar

if [ ! "$(docker ps -a -q -f 'name=graal-builder')" ]; then
  echo "DB container does not exists, creating it"
  docker run --name graal-builder -dt graal-build-img:latest /bin/bash
else
  echo "Container already running"
fi
set -eu

docker cp target/uberjar/server.jar graal-builder:server.jar

docker exec graal-builder native-image -H:+ReportUnsupportedElementsAtRuntime -H:EnableURLProtocols=http,https -J-Xmx3G -J-Xms3G --no-server -jar server.jar --rerun-class-initialization-at-runtime=org.httpkit.client.SslContextFactory --rerun-class-initialization-at-runtime=org.httpkit.client.HttpClient

docker cp graal-builder:server target/server
zip -j target/bundle.zip src/bootstrap target/server