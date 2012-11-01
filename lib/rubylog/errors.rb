module Rubylog
  class RubylogError < StandardError 
  end

  class DiscontiguousPredicateError < RubylogError
  end

  class MultitheoryError < RubylogError
  end

  class BuiltinPredicateError < RubylogError
  end

  class ExistenceError < RubylogError
  end

  class InvalidStateError < RubylogError
  end

  class InstantiationError < RubylogError
  end

  class TypeError < RubylogError
  end

  class UnknownVariableError < RubylogError
  end

  class CheckFailed < StandardError
  end

end

