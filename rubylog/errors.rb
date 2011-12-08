module Rubylog
  class RubylogError < StandardError 
  end

  class DiscontinuousPredicateError < RubylogError
  end

  class BuiltinPredicateError < RubylogError
  end

end

