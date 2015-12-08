(ns java-interop.test6
  (:import java_interop.Example6))

(Example6/greet)   ;=> "Hello, World!"

(.greetMessage (Example6.) "Rich Hickey")

