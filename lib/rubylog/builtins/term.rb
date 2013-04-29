Rubylog do

  class << primitives_for Rubylog::Term
    # = is
    def is a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { yield }
    end

    def is_not a,b
      a = a.rubylog_resolve_function
      b = b.rubylog_resolve_function
      a.rubylog_unify(b) { return }
      yield
    end

    # member
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

    def not_in a, b
      self.in(a, b) { return }
      yield
    end
  end
end
