class Symbol
  include ::Rubylog::Term

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
