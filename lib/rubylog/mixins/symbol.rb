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

  def predicate
    Rubylog::DefaultBuiltins[indicator] or raise Rubylog::ExistenceError.new(indicator)
  end

  # Assertable methods
  include Rubylog::Assertable

  # Term methods
  include Rubylog::Term

  # Callable methods
  include Rubylog::Callable

  def prove
    begin
      Rubylog.print_trace 1, self, rubylog_variables_hash
      predicate.call(*args) { yield }
    ensure
      Rubylog.print_trace -1
    end
  end


end
