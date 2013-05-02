require "rspec"
require "rubylog"

# This module is included in RSpecExampleGroup's with rubylog:true metadata.
#
module Rubylog::RSpecExampleGroup
  def self.included example_group
    # Make it a context
    example_group.extend Rubylog::Context
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


