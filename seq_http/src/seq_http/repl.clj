(ns seq_http.repl
  (:use seq_http.handler
        ring.server.standalone))

(defonce server (atom nil))

(defn get-handler []
  ;; #'app expands to (var app) so that when we reload our code,
  ;; the server is forced to re-resolve the symbol in the var
  ;; rather than having its own copy. When the root binding
  ;; changes, the server picks it up without having to httpart.
  (-> #'app ))

(defn start-server
  "used for starting the server in development mode from REPL"
  [& [port]]
  (let [port (if port (Integer/parseInt port) 9000)]
    (reset! server
            (serve (get-handler)
                   {:port port
                    :init init
                    :open-browser? false
                    :auto-reload? true
                    :destroy destroy
                    :join true}))
    (println (str "You can view the site at http://localhost:" port))))

(defn stop-server []
  (.stop @server)
  (reset! server nil))
