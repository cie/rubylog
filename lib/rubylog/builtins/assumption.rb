Rubylog.theory "Rubylog::SuppositionBuiltins", nil do
  subject ::Rubylog::Callable, ::Rubylog::Structure, Symbol, Proc

  class << primitives
    def ensure a, b
      begin
        a.prove { yield }
      ensure
        b.prove {}
      end
    end

    def together a, b
      c = []
      a.prove {
        c << b.rubylog_resolve_function
      }
      c.inject{|a,b|a.and b}.solve {
        yield
      }
    end

  end

  functor :assumed, :ignored, :together

  A.assumed.if proc {
    theory = ::Rubylog.current_theory

    original_last_predicate = theory.last_predicate
    theory.last_predicate = theory[A.indicator]

    theory.assert A 

    theory.last_predicate = original_last_predicate

    true
  }.ensure {
    theory = ::Rubylog.current_theory

    theory[A.indicator].retractz 
  }

end

Rubylog::DefaultBuiltins.amend do
  include_theory Rubylog::SuppositionBuiltins
end
