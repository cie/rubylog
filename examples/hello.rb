require "../rubylog.rb"

Rubylog.use :variables, String

A.write.if {|a| puts a}
:hello.if "Hello, world!".write

:hello.true?

