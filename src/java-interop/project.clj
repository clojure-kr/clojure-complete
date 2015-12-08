(defproject java-interop "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]]
  :aot [java-interop.example1 java-interop.example2
        java-interop.Example3 java-interop.Example4
        java-interop.Example5 java-interop.Example6])
