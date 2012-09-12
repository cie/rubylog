class Symbol

  # a proxy for Clause
  def functor
    self
  end

  def arity
    0
  end

  def desc
    [self, 0]
  end

  def args
    []
  end

  # Assertable methods
  include Rubylog::Assertable

  # Unifiable methods
  include Rubylog::Unifiable

  # Callable methods
  include Rubylog::Callable

  def prove
    predicate = Rubylog.theory[self][0]
    raise Rubylog::ExistenceError, desc.inspect if not predicate
    predicate.call(*args) { yield }
  end

  # Second-order functors (:is_false, :and, :or, :then)
  include Rubylog::DSL::SecondOrderFunctors

end
