$: << File.expand_path(__FILE__+"/../lib")

require 'rubylog'


theory = Rubylog::Theory.new do
  A.write.if {|a| puts a or true}
  :hello.if "Hello, world!".write
end

theory.prove :hello

