class Symbol

  def predicate
    Rubylog::NullaryPredicates[self] or raise Rubylog::ExistenceError.new(self)
  end

  def args
    []
  end

  # Assertable methods
  include Rubylog::Assertable

  # Term methods
  include Rubylog::Term

  # Clause methods
  include Rubylog::Clause

  def prove
    predicate.call { yield }
  end

  rubylog_traceable :prove


end
