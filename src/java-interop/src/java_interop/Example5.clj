(ns java-interop.Example5
  (:gen-class
   :implements   [clojure.lang.IDeref]
   :state        state
   :init         init
   :constructors {[String] []}))

(defn -init
  [message]
  [[] (atom message)])

(defn -deref
  [this]
  @(.state this))
