module Rubylog

  class RubylogError < StandardError 
  end
  
  class SyntaxError < RubylogError
  end

  class DiscontiguousPredicateError < RubylogError
    def initialize indicator
      super "Predicate #{Rubylog::Structure.humanize_indicator(indicator)} was not declared as discontiguous"
    end
  end

  class MultitheoryError < RubylogError
    def initialize indicator
      super "Predicate #{Rubylog::Structure.humanize_indicator(indicator)} was not declared as multi-theory"
    end
  end

  class BuiltinPredicateError < RubylogError
    def initialize indicator
      super "Predicate #{Rubylog::Structure.humanize_indicator(indicator)} is built-in"
    end
  end

  class NonAssertableError < RubylogError
    def initialize indicator
      super "Predicate #{Rubylog::Structure.humanize_indicator(indicator)} is not assertable"
    end
  end

  class ExistenceError < RubylogError
    def initialize indicator
      super "Predicate #{Rubylog::Structure.humanize_indicator(indicator)} does not exist"
    end
  end

  class InvalidStateError < RubylogError
  end

  class InstantiationError < RubylogError
    def initialize functor, args
      super "Instantiation error in #{Rubylog::Structure.new(functor, *args).inspect}"
    end
  end

  class TypeError < RubylogError
  end

  class UnknownVariableError < RubylogError
  end

  class CheckFailed < StandardError
    def initialize goal
      super "Check failed #{goal.inspect}"
    end
  end

end

