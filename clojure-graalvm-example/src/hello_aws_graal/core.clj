(ns hello-aws-graal.core
    (:require [org.httpkit.client :as http])
    (:gen-class))

(defn -main
  [& args]
  ; Before looping endpoint runtime should initialize itself like creating db pools and so on. If error is happened during this
  ; runtime should make POST request to /runtime/init/error endpoint
  (while true
     (let [runtime (System/getenv "AWS_LAMBDA_RUNTIME_API")
           request @(http/get (str "http://" runtime "/2018-06-01/runtime/invocation/next"))
           headers (:headers request)
           {:keys [lambda-runtime-aws-request-id]} headers
           response-body "{\n  \"headers\": {\n    \"content-type\": \"text/html\"\n  },\n  \"isBase64Encoded\": false,\n  \"body\": \"Hello Graal World\",\n  \"statusCode\": 200\n}"]
          @(http/post (str "http://" runtime "/2018-06-01/runtime/invocation/" lambda-runtime-aws-request-id "/response")
                      {:body response-body})
          ;; if runtime cannot handle the request it should make POST request to /runtime/invocation/AwsRequestId/error endpoint
          )))
