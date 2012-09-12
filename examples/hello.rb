$:.unshift File.dirname(__FILE__)+"/../lib"

require 'rubylog'

theory = Rubylog::Theory.new do
  functor :write
  used_by String

  A.write.if {|a| puts a; true}
  :hello.if "Hello, world!".write
end

theory.prove :hello

