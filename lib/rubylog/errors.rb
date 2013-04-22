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

  class ExistenceError < RubylogError
    def initialize clause
      super "Predicate #{clause.inspect} does not exist"
    end
  end

  class InvalidStateError < RubylogError
  end

  class InstantiationError < RubylogError
    def initialize functor, args=nil
      if args
        super "Instantiation error in #{args[0].inspect}.#{functor}(#{args[1..-1].map{|a|a.rubylog_deep_dereference.inspect}.join(", ")})"
      else
        super "Instantiation error in #{functor.inspect}"
      end
    end
  end

  class CheckFailed < StandardError
    def initialize goal
      super "Check failed #{goal.inspect}"
    end
  end

end

