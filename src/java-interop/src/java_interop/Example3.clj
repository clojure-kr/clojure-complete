(ns java-interop.Example3
  (:gen-class
   :implements [clojure.lang.IDeref]))

(defn -deref
  [this]
  "Hello, World!")
