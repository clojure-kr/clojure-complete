(ns java-interop.test2
  (:import (java_interop.example1 MyClassA MyClassB))

(.toString (MyClassA.))   ;=> "I'm an A."
(.toString (MyClassB.))   ;=> "I'm an B."

