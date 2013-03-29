module Rubylog::TheoryModules
  module Demonstration
    def solve goal, &block
      goal ||= block
      raise ArgumentError, "No goal given", caller if goal.nil?
      goal.solve &block
    end

    def true? goal=nil, &block
      goal ||= block
      raise ArgumentError, "No goal given", caller if goal.nil?
      goal.true?
    end

  end
end
