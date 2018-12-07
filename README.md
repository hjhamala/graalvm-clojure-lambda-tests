# Clojure GraalVM testing samples

This repository contains AWS Lambda test programs for Clojure JVM, Clojure GraalVM, regular 
Java and Python.

Create a common infrastructure with command:

```
aws cloudformation deploy --stack-name=graal-test-common-infra --template-file=common-infra.yml --capabilities=CAPABILITY_IAM
```

Create Docker image for GraalVM compilation with command:
````
docker build -t graal-build-img .
````

Create API gateways by running update-aws.sh script in the application directories.

Run the tests with using test.sh script. 
 



