Rubylog.theory "Rubylog::TermBuiltins", nil do
  subject ::Rubylog::Term

  class << primitives
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
      if b.instance_of? Rubylog::Variable
        raise Rubylog::InstantiationError.new b
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

Rubylog::DefaultBuiltins.amend do
  include_theory Rubylog::TermBuiltins
end
