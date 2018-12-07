#!/usr/bin/env bash
echo "Building Clojure uberjar"
lein uberjar

if [ ! "$(docker ps -a -q -f 'name=graal-builder')" ]; then
  echo "DB container does not exists, creating it"
  docker run --name graal-builder -dt graal-build-img:latest
else
  echo "Container already running"
fi
set -eu

docker cp target/uberjar/server.jar graal-builder:server.jar

docker exec graal-builder native-image -H:+ReportUnsupportedElementsAtRuntime -H:EnableURLProtocols=http,https -J-Xmx3G -J-Xms3G --no-server -jar server.jar --rerun-class-initialization-at-runtime=org.httpkit.client.SslContextFactory --rerun-class-initialization-at-runtime=org.httpkit.client.HttpClient

docker cp graal-builder:server target/server
docker cp graal-builder:/opt/graalvm-ce-1.0.0-rc9/jre/lib/amd64/libsunec.so target/libsunec.so
docker cp graal-builder:libsunec.so target/libsunec.so
zip -j target/bundle.zip src/bootstrap target/server target/libsunec.so

TIMESTAMP=$(date +%s)
echo $TIMESTAMP.zip > latest.tag
aws s3 cp target/bundle.zip s3://$(aws ssm get-parameter --name=/graalvm-test/s3-artifact-bucket | jq -r '.Parameter.Value')/$TIMESTAMP.zip

aws cloudformation deploy --stack-name=graal-infra --template-file=../lambda.yml --parameter-overrides \
    CodeTag=$TIMESTAMP.zip \
    Runtime=provided \
    FunctionName=graalvm-test \
    Handler=not.needed \
    Memory=1000

ENDPOINT=$(aws cloudformation describe-stacks --stack-name=graal-infra| jq -r '.Stacks[0].Outputs[0].OutputValue')
echo "Test the api at $ENDPOINT"
echo $ENDPOINT > endpoint.uri
