require 'rubylog'

Rubylog.use :variables, :implicit_predicates, String

Rubylog::Theory.new do
  A.write.if {|a| puts a or true}
  :hello.if "Hello, world!".write
  :hello.prove
end



