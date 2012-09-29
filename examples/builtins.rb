$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory "Try" do
  subject String

  def primitives.hello
    puts "Hello"
    yield
  end

  def primitives.hello x
    puts "Hello #{x}!"
    yield
  end

  :hello_world.if "World".hello

end


p Try.prove :hello
p Try.prove :hello_world
