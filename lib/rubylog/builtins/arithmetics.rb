Rubylog::DefaultBuiltins.amend do

  class << primitives_for Numeric
    def sum_of c, a, b
      a, b, c = [a,b,c].map{|f|f.rubylog_resolve_function.rubylog_dereference}
      a_var, b_var, c_var = [a,b,c].map{|f|f.is_a? Rubylog::Variable}

      case
      when !a_var && !b_var
        c.rubylog_unify(a+b) { yield }
      when !c_var && !b_var
        a.rubylog_unify(c-b) { yield }
      when !c_var && !a_var
        b.rubylog_unify(c-a) { yield }
      else
        raise Rubylog::InstantiationError.new :sum_of, [c, a, b]
      end

    end

  end
end

