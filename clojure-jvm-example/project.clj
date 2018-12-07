(defproject hello-aws-clojure "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.9.0"]
                 [uswitch/lambada "0.1.2"]]
  :main ^:skip-aot hello-aws-clojure.core
  :target-path "target/%s"
  :uberjar-name "server.jar"
  :profiles {:uberjar {:aot :all}})
