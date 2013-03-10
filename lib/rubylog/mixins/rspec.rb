require "rspec"

module Rubylog::RSpecExampleGroup
  def self.included example_group
    example_group.extend Rubylog::Theory
    example_group.extend Rubylog::RSpecExampleGroup::ClassMethods
  end

  module ClassMethods
    def check goal, &block
      specify do
        check goal, &block
      end
    end
  end
end

RSpec.configure do |c|

  c.include Rubylog::RSpecExampleGroup, :rubylog => true

  c.before do
    if self.class.metadata[:rubylog]
      Rubylog.create_theory self
      m = self.class
      include_theory self.class
      while m = eval(m.name.rpartition("::")[0]) and m.include? Rubylog::RSpecExampleGroup
        include_theory m
      end
      Rubylog.static_current_theory = self
    end
  end
end


