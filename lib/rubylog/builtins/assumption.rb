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

  class << primitives
    def revoked h
      h = h.rubylog_dereference
      raise Rubylog::InstantiationError, [:revoked, h] if h.is_a? Rubylog::Variable
      raise Rubylog::TypeError, [:revoked, h] unless h.respond_to? :indicator

      predicate = ::Rubylog.current_theory[h.indicator]

      (0...predicate.count).each do |i|
        r = predicate.delete_at(i)
        begin
          rule = r.rubylog_compile_variables
          head, body = rule[0], rule[1]
          head.args.rubylog_unify h.args do
            body.prove do
              yield
            end
          end
        ensure
          predicate.insert(i, r)
        end
      end
    end
  end


end

Rubylog::DefaultBuiltins.amend do
  include_theory Rubylog::SuppositionBuiltins
end
