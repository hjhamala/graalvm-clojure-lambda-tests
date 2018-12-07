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

Create API gateway by running 
<pre>./update-aws.sh</pre> 
script in the application directories.


After the update script has run it prints the uri for testing the endpoint. Script also create endpoint.uri an latest.tag files 
which are used by the testing scripts.

Run the test with 
<pre>./test.sh</pre>. 

The tests work by updating the function code with the latest tag. This causes Lambda to cold start
the next invocation. Curl is used to measure time for the cold start and result is written to cold.txt in format *http-code,time-in-seconds*. 
Then the script makes five consecutive calls to the Lambda and writes the results to warm.txt. Use your preferred way to calculate statistics
from the files.

 
## GraalVM HTTPS support
There is example Dockerfile with HTTPS workarounds, you can use it to create Docker image for
GraalVM compilation with command: 
````
docker build -f Dockerfile.https -t graal-build-img .
````
and then use script *update-aws-https.sh* to load compiled program to AWS Lambda.



