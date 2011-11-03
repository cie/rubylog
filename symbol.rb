class Symbol
  include Rubylog::Term

  def functor
    self
  end

  def arity
    0
  end

  def desc
    Clause.new :/, functor, arity
  end

  def args
    []
  end
end
