module Rubylog

  class RubylogError < StandardError 
    def initialize *args
      super

      remove_internal_lines
    end

    def remove_internal_lines
      internal_dir = File.dirname(__FILE__) or return
      return unless backtrace
      index = backtrace.index{|l| not l.start_with?(internal_dir) } or return
      set_backtrace backtrace[index..-1]
    end
  end
  
  class SyntaxError < RubylogError
  end

  class BuiltinPredicateError < RubylogError
    def initialize predicate
      super "Predicate #{predicate.inspect} is built-in"
    end
  end

  class NonAssertableError < RubylogError
    def initialize predicate
      super "Predicate #{predicate.inspect} is not assertable"
    end
  end

  class ExistenceError < RubylogError
    def initialize predicate
      super "Predicate #{predicate.inspect} does not exist"
    end
  end

  class InvalidStateError < RubylogError
  end

  class InstantiationError < RubylogError
    def initialize predicate
      super "Instantiation error in #{predicate.inspect}"
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

