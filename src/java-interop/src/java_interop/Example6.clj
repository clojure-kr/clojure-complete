(ns java-interop.Example6
  (:gen-class
   :methods [^:static [greet [] String]
                      [greetMessage [String] String]]))

(defn -greet
  []
  "Hello, World!")

(defn -greetMessage
  [this msg]
  (str "Hello, " msg "!"))
