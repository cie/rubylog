Rubylog do
  predicate_for ::Rubylog::Assertable, ".assumed", ".rejected", ".revoked", ".assumed_if()", ".assumed_unless()", ".rejected_if()", ".rejected_unless()"

  A.assumed.if A.assumed_if :true
  A.rejected.if A.assumed_if :cut!.and :fail
  H.rejected_if(B).if H.assumed_if(B.and :cut!.and :fail)
  H.rejected_unless(B).if H.assumed_if(B.false.and :cut!.and :fail)
  H.assumed_unless(B).if H.assumed_if(B.false)

  H.assumed_if(B).if proc {
    raise Rubylog::InstantiationError.new :assumed_if, [H, B] if !H or !B

    # assert
    H.predicate.unshift Rubylog::Rule.new(H, B)
    
    true
  }.ensure {
    # retract
    H.predicate.shift
  }

  class << primitives_for ::Rubylog::Assertable
    def revoked h
      h = h.rubylog_dereference
      raise Rubylog::InstantiationError.new :revoked, [h] if h.is_a? Rubylog::Variable

      predicate = h.predicate

      (0...predicate.count).each do |i|
        r = predicate.delete_at(i)
        begin
          rule = r.rubylog_compile_variables
          rule.head.args.rubylog_unify h.args do
            rule.body.prove do
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

