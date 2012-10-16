theory "Rubylog::Reflection", nil do
  def primitives.predicate l
    _functor = Rubylog::Variable.new(:_functor)
    _arity = Rubylog::Variable.new(:_arity)
    l.rubylog_unify [f, a] do
      if f = _functor.value
        # TODO
      else
        # TODO
      end
    end
  end
end
