class Rubylog::Primitives
  def initialize theory
    @theory = theory
  end

  def singleton_method_added name
    unless name == :singleton_method_added
      m = method(name)
      @theory.functor name unless m.arity.zero?
      @theory[name][m.arity] = m
    end
  end
end
