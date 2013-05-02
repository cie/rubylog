$:.unshift File.dirname(__FILE__)+"/../lib"

require 'rubylog'


rubylog do
  predicate_for String, ".written :hello"

  X.written.if {puts X; true}

  :hello.if "Hello world!".written
end

rubylog do
  solve :hello
end

