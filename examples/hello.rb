$:.unshift File.dirname(__FILE__)+"/../lib"

require 'rubylog'


HelloTheory = Rubylog.create_context do
  predicate_for String, ".written"

  X.written.if {puts X; true}

  :hello.if "Hello, world!".written
end

HelloTheory.solve :hello

