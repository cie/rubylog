require 'rubylog/builtins/ensure'

Rubylog.theory "Rubylog::AssumptionBuiltins", nil do
  include_theory Rubylog::EnsureBuiltins
  
  subject ::Rubylog::Callable, ::Rubylog::Structure, Symbol, Proc
  functor :assumed, :rejected, :revoked, :assumed_if

  A.assumed.if A.assumed_if :true
  A.rejected.if A.assumed_if :cut!.and :fail

  H.assumed_if(B).if proc {
    raise Rubylog::InstantiationError.new :assumed_if, [H, B] if !H or !B
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
      raise Rubylog::InstantiationError.new :revoked, [h] if h.is_a? Rubylog::Variable
      raise Rubylog::TypeError.new :revoked, [h] unless h.respond_to? :indicator

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
  include_theory Rubylog::AssumptionBuiltins
end
