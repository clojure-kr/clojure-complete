(ns java-interop.test1
  (:import java_interop.example1.MyClass))

(.toString (MyClass.))   ;=> "Hello, World!"

