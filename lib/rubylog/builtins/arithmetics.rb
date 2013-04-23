Rubylog do

  class << primitives_for Numeric
    # Succeeds if +c+ unifies with the sum of +a+ and +b+ if +a+ and +b+ is given.
    # Succeeds if +a+ unifies with the difference of +c+ and +b+ if +c+ and +b+ is given.
    # Succeeds if +b+ unifies with the difference of +c+ and +a+ if +c+ and +a+ is given.
    #
    # +a+ and +b+ can be procs.
    #
    # Please beware that unification requires equality by type, so 4.sum_of(2, 2.0) will fail.
    #
    # It can add any type of object that responds_to + and/or -:
    #     A.sum_of(B,C).predicate.add_functor_to String
    #     check "hello".sum_of("he", "llo")
    #
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

