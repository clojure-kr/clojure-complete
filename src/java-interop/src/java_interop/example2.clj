(ns java-interop.example2)

(gen-class
  :name   java_interop.example1.MyClassA
  :prefix classA-)

(gen-class
  :name   java_interop.example1.MyClassB
  :prefix classB-)

(defn classA-toString
  [this]
  "I'm an A.")

(defn classB-toString
  [this]
  "I'm a B.")
