require "rspec"
require "rubylog"

module Rubylog::RSpecExampleGroup
  def self.included example_group
    example_group.extend Rubylog::Theory
    example_group.extend Rubylog::RSpecExampleGroup::ClassMethods
  end

  module ClassMethods
    def check goal=nil, &block
      options = build_metadata_hash_from([])
      desc = (goal ? goal.inspect : block.inspect)
      examples << RSpec::Core::Example.new(self, desc, options, proc{check goal, &block})
      examples.last
    end

    def inherited subclass
      super
      subclass.initialize_theory
    end
  end
end

RSpec.configure do |c|

  # enable use of Rubylog in example groups
  c.include Rubylog::RSpecExampleGroup, :rubylog => true

  # enable use of Rubylog in examples
  c.before do
    if self.class.metadata[:rubylog]
      # create the theory from the example
      Rubylog.create_theory self

      # include the EG class
      include_theory self.class

      # include nesting example groups upwards while they are rubylog example groups
      m = self.class
      while m = eval(m.name.rpartition("::")[0]) and m.include? Rubylog::RSpecExampleGroup
        include_theory m
      end

      # set the static current theory
      Rubylog.static_current_theory = self
    end
  end
end


