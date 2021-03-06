rubylog do

  class << primitives_for Rubylog::Term
    # Unifies +a+ with +b+. Both can be a proc, which is then called and the result
    # is taken.
    def is a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { yield }
    end

    # Unifies +a+ with +b+. Fails if the unification succeeds, otherwise succeeds.
    #
    # Both +a+ and +b+ can be a proc, which is then called and the result
    # is taken.
    def is_not a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { return }
      yield
    end

    # Unifies +a+ with each member of enumerable +b+
    #
    # Both +a+ and +b+ can be a proc, which is then called and the result
    # is taken.
    def in a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function.rubylog_dereference
      if b.is_a? Rubylog::Variable
        raise Rubylog::InstantiationError.new :in, [a,b]
      else
        b.each do |e|
          a.rubylog_unify(e) { yield }
        end
      end
    end

    # Succeeds if +a+ cannot be unified with any member of enumerable +b+.
    def not_in a, b
      self.in(a, b) { return }
      yield
    end
  end
end
