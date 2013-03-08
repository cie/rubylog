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

  functor :assumed, :rejected, :revoked, :assumed_if

  A.assumed.if A.assumed_if :true
  A.rejected.if A.assumed_if :cut!.and :fail

  H.assumed_if(B).if proc {
    raise Rubylog::InstantiationError, [:assumed_if, H, B] if !H or !B
    theory = ::Rubylog.current_theory
    predicate = theory[H.indicator]

    theory.check_exists predicate, H

    predicate.asserta Rubylog::Structure.new(:-, H, B)
    
    true
  }.ensure {
    theory = ::Rubylog.current_theory
    theory[H.indicator].retracta
  }

end

Rubylog::DefaultBuiltins.amend do
  include_theory Rubylog::SuppositionBuiltins
end
