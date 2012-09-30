Rubylog.theory "Rubylog::BuiltinsForClause", nil do
  class << primitives

    def clause c, fct, args
      c = c.rubylog_dereference
      if c.is_a? Rubylog::Variable
        c.rubylog_unify Clause.new(fct, *args) { yield }
      elsif c.is_a? Rubylog::Clause
        c.functor.rubylog_unify fct do
          c.args.rubylog_unify args do
            yield
          end
        end
      end
    end

  end
end
