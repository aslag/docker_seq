(ns seq_http.handler
  (:use ring.util.response)
  (:require [compojure.core :refer :all]
            [compojure.handler :as handler]
            [compojure.route :as route]
            [ring.middleware.json :as middleware]))

(defn init []
  (println "seq_http is starting"))

(defn destroy []
  (println "seq_http is shutting down"))

(defroutes app-routes
  ; context for entire app
  (context "/api" []
    (GET "/repeat" [x n] (response (str "repeat " x n "times")))
    (GET "/count/:n" [n] (response (str "count to " n)))
    (GET "/fib/:n" [n] (response (str "fibs to " n))))
  (route/not-found "not found"))

(def app
  (-> (handler/api app-routes)
      (middleware/wrap-json-body)
      (middleware/wrap-json-response)))
