module Rubylog::DefaultContext

  predicate_for ::Rubylog::Assertable, ".assumed", ".rejected", ".revoked", ".assumed_if()", ".assumed_unless()", ".rejected_if()", ".rejected_unless()"

  # Asserts a rule with head H and body B in the predicate of H. It retracts it
  # at backtracking.
  H.assumed_if(B).if proc {
    raise Rubylog::InstantiationError.new :assumed_if, [H, B] if !H or !B

    # assert
    H.predicate.unshift Rubylog::Rule.new(H, B)
    
    true
  }.ensure {
    # retract
    H.predicate.shift
  }

  # Asserts a fact A to the predicate of A.
  # The clause is retracted at backtracking.
  A.assumed.if A.assumed_if :true

  # Asserts a rule H.if(B.false) in the predicate of H.
  # The clause is retracted at backtracking.
  H.assumed_unless(B).if H.assumed_if(B.false)

  # Asserts a rule A.if(:cut!.and(:fail)) in the predicate of A.
  # The clause is retracted at backtracking.
  A.rejected.if A.assumed_if :cut!.and :fail

  # Asserts a rule H.if(B.and :cut!.and(:fail)) in the predicate of H.
  # The clause is retracted at backtracking.
  H.rejected_if(B).if H.assumed_if(B.and :cut!.and :fail)

  # Asserts a rule H.if(B.false.and :cut!.and(:fail)) in the predicate of H.
  # The clause is retracted at backtracking.
  H.rejected_unless(B).if H.assumed_if(B.false.and :cut!.and :fail)



  class << primitives_for ::Rubylog::Assertable
    # Retracts a rule from the predicate of +h+. At backtracking, the rule is
    # re-asserted.  It consequently succeeds with each rule in the predicate
    # retracted.    
    #
    def revoked h
      h = h.rubylog_dereference
      raise Rubylog::InstantiationError.new :revoked, [h] if h.is_a? Rubylog::Variable

      predicate = h.predicate

      (0...predicate.size).each do |i|
        # retract the clause
        r = predicate.delete_at(i)
        begin
          rule = r.rubylog_match_variables
          rule.head.args.rubylog_unify h.args do
            rule.body.prove do
              yield
            end
          end
        ensure
          # re-assert the clause
          predicate.insert(i, r)
        end
      end
    end
  end


end

