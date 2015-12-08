(ns java-interop.example1)

(gen-class
  :name java_interop.example1.MyClass)

(defn -toString
  [this]
  "Hello, World!")
