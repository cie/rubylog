require "rspec"
require "rubylog"

# This module is included in RSpecExampleGroup's with rubylog:true metadata.
#
module Rubylog::RSpecExampleGroup
  def self.included example_group
    # Make it a context
    example_group.extend Rubylog::Context
    # Add helper methods
    example_group.extend Rubylog::RSpecExampleGroup::ClassMethods
  end

  module ClassMethods
    # Creates a new example. This is just a shorthand for specify { check ... }
    #
    def check goal=nil, &block
      options = build_metadata_hash_from([])
      desc = (goal ? goal.inspect : block.inspect)
      examples << RSpec::Core::Example.new(self, desc, options, proc{check goal, &block})
      examples.last
    end

    def inherited subclass
      super
      # When a subclass (a sub-example-group) is created, we initialize it. We
      # do not have to include Rubylog::Context in it because it is included in
      # the superclass (self). We no not either extend Rubylog::Context in it
      # because self.singleton_class.instance_methods are available in
      # subclass.singleton_class. However, we need to initialize it.
      subclass.initialize_context
    end
  end
end

RSpec.configure do |c|

  # enable use of Rubylog in example groups
  c.include Rubylog::RSpecExampleGroup, :rubylog => true

  # enable use of Rubylog in examples
  c.before do
    # when :rubylog=>true is given
    if self.class.metadata[:rubylog]
      # create the context from the example
      # this initializes the context
      Rubylog.create_context self
    end
  end
end


