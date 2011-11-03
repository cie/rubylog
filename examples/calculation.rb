require "rubylog"

Rubylog.use :variables, :implicit_predicates, String

A.write.if {|a| puts a; true}
:hello.if "Hello, world!".write

:hello.true?


