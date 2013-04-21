class Symbol

  def predicate
    Rubylog::NullaryPredicates[self] or raise Rubylog::ExistenceError.new(self)
  end

  # Assertable methods
  include Rubylog::Assertable

  # Term methods
  include Rubylog::Term

  # Callable methods
  include Rubylog::Callable

  def prove
    predicate.call { yield }
  end

  rubylog_traceable :prove


end
