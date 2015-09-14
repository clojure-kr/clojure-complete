#!/usr/bin/env ruby

$dirs = %w(Why-Clojure Development-Environments Leiningen Start Basic-Data-Types
	   Flow-Controls Collections-and-Data-Structures Functions-and-Functional-Programming
	   Destructuring Recursions Transducers Java-Interoperability Metadata
           Namespaces-and-Libraries State-Management-and-Parallel-Programming Core-Async
           Multimedthos-and-Hierarchies Protocols-Records-and-Types Macros
           Numerics-and-Mathematics Project-Management Testing Type-Checking
           Database-Programming Web-Programming)

def init_dirs ()
  $dirs.each do |dir|
    `rm -rf #{dir}`
    `mkdir #{dir}`
    `touch "#{dir}/#{dir.downcase}.adoc"`
  end
end

def remove_htmls ()
  $dirs.each do |dir|
    `rm "#{dir}/#{dir.downcase}.html"`
  end
end

# remove_htmls
  
  
