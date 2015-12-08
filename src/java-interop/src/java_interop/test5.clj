(ns java-interop.test5
  (:import java_interop.Example5))

(def o (Example5. "Hello, there!"))

@o   ;=> "Hallo, there!"

(reset! (.state o) "Good morning, everybody!")

@o   ;=> "Good morning, everybody!"

