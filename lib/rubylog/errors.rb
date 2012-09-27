module Rubylog
  class RubylogError < StandardError 
  end

  class DiscontiguousPredicateError < RubylogError
  end

  class BuiltinPredicateError < RubylogError
  end

  class ExistenceError < RubylogError
  end

  class InvalidStateError < RubylogError
  end

end

