Rubylog do

  class << primitives_for Rubylog::Term
    # = is
    def is a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      # the order is chosen based on inriasuite's requirements. Where it matters
      # is A=B, write(A)
      b.rubylog_unify(a) { yield }
    end

    def is_not a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      b.rubylog_unify(a) { return }
      yield
    end

    # member
    def in a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function.rubylog_dereference
      if b.instance_of? Rubylog::Variable
        raise Rubylog::InstantiationError.new :in, [a,b]
      else
        b.each do |e|
          a.rubylog_unify(e) { yield }
        end
      end
    end

    def not_in a, b
      self.in(a, b) { return }
      yield
    end
  end
end
