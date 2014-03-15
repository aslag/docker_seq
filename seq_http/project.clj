(defproject seq_http "0.1.0-SNAPSHOT"
  :description "HTTP service that generates basic mathematical sequences given input"
  :url "https://github.com/aslag/docker_seq"
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [compojure "1.1.6"]
                 [ring "1.2.1"]
                 [ring-server "0.3.1"]
                 [ring/ring-json "0.2.0"]
                 [ring/ring-codec "1.0.0"]]
  :plugins [[lein-ring "0.8.10"]]
  :ring {:handler seq_http.handler/app
         :init seq_http.handler/init
         :destroy seq_http.handler/destroy}
  :profiles {:dev {:dependencies [[javax.servlet/servlet-api "2.5"]
                        [ring-mock "0.1.5"]
                        [ring/ring-devel "1.2.0"]]}})
