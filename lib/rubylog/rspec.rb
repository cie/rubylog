require "rspec"

module Rubylog::RSpec
  module CheckMethods
    def check_raised_exception goal, exception
      raise exception
    end

    def check_failed goal
      raise Rubylog::CheckFailed.new goal
    end

    def check_passed goal
    end
  end
end

RSpec.configure do |c|
  c.before do
    if self.class.metadata[:rubylog]
      Rubylog.create_theory self
      include_theory Rubylog::DefaultBuiltins
      self.extend Rubylog::RSpec::CheckMethods
      Rubylog.static_current_theory = self
    end
  end
end


