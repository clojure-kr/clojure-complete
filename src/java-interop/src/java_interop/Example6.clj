(ns java-interop.Example6
  (:gen-class
   :methods [^:static [greet [] String]
                      [greetMessage [String] String]]))

(defn -greet
  []
  (println "show called.")
  "Hello, World!")

(defn -greetMessage
  [this msg]
  (println "showMessage called.")
  (str "Hello, " msg "!"))
