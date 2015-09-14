(ns clojure-programming.namespace
  ;(:refer-clojure :exclude [inc])
  (:gen-class))

;(refer-clojure :exclude [inc])

(defn inc []
  "my inc function.")
 
(defn -main [& args]
  (println "inc: " (inc)))



