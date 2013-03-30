class Symbol

  # a proxy for Structure
  def functor
    self
  end

  def arity
    0
  end

  def indicator
    [self, 0]
  end

  def args
    []
  end

  def theory
    Rubylog::DefaultBuiltins
  end

  # Assertable methods
  include Rubylog::Assertable

  # Term methods
  include Rubylog::Term

  # Callable methods
  include Rubylog::Callable

  def prove
    begin
      theory.print_trace 1, self, rubylog_variables_hash

      predicate = theory[[self,0]]
      raise Rubylog::ExistenceError.new theory, indicator if not predicate

      predicate.call(*args) { yield }

    ensure
      theory.print_trace -1
    end
  end


end
