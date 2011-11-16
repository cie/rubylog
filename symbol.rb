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
end
