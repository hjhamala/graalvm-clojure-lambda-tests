(ns hello-aws-clojure.core
  (:require [uswitch.lambada.core :refer [deflambdafn]]
            [clojure.java.io :as io]))

(deflambdafn Lambda
  [in out ctx]
  (with-open [w (io/writer out)]
    (.write w "{\n  \"headers\": {\n    \"content-type\": \"text/html\"\n  },\n  \"isBase64Encoded\": false,\n  \"body\": \"Hello Clojure World\",\n  \"statusCode\": 200\n}")))


