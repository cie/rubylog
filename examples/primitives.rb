$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory "Try" do
  subject String
  predicate ":hello_world"

  def primitives.hello
    puts "Hello"
    yield
  end

  def primitives.hello x
    puts "Hello #{x.rubylog_deep_dereference}!"
    yield
  end

  :hello_world.if "World".hello

end


p Try.true? :hello
p Try.true? :hello_world
p Try.true?{X.is("World").and X.hello}
