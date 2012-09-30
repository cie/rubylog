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
    Rubylog.current_theory.print_trace 1, self, Rubylog::InternalHelpers.vars_hash_of(self)
    predicate = Rubylog.current_theory[self][0]
    raise Rubylog::ExistenceError, desc.inspect if not predicate
    predicate.call(*args) { yield }
    Rubylog.current_theory.print_trace -1
  end

  # Second-order functors (:is_false, :and, :or, :then)
  include Rubylog::DSL::SecondOrderFunctors

end
