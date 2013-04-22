require "rspec"
require "rubylog"

module Rubylog::RSpecExampleGroup
  def self.included example_group
    example_group.extend Rubylog::Context
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
      subclass.initialize_context
    end
  end
end

RSpec.configure do |c|

  # enable use of Rubylog in example groups
  c.include Rubylog::RSpecExampleGroup, :rubylog => true

  # enable use of Rubylog in examples
  c.before do
    if self.class.metadata[:rubylog]
      # create the context from the example
      Rubylog.create_context self
    end
  end
end


