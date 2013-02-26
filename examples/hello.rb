$:.unshift File.dirname(__FILE__)+"/../lib"

require 'rubylog'


HelloTheory = theory do
  functor_for String, :written

  X.written.if {puts X; true}

  :hello.if "Hello, world!".written
end

HelloTheory.prove :hello

