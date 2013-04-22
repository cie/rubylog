$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Try = Rubylog.create_context
Try.instance_exec do
  predicate ":hello_world"

  def primitives.hello
    puts "Hello"
    yield
  end

  class << primitives_for(String)
    def hello x
      puts "Hello #{x.rubylog_deep_dereference}!"
      yield
    end
  end

  :hello_world.if "World".hello

end


p Try.true? :hello
p Try.true? :hello_world
