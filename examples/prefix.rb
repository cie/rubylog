require "rubylog"
extend Rubylog::Context

predicate_for Kernel, ".hello()"

hello!(2)
hello(5).if { puts "Hello" }

hello?(5)

check hello(2)
check hello(4).false

