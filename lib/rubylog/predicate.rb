
module Rubylog
  class Predicate < Array
    # accepts the *args of the called clause
    def call *args
      begin
        each do |rule|
          rule = rule.rubylog_compile_variables
          head, body = rule[0], rule[1]
          head.args.rubylog_unify(args) { 
            Rubylog.current_theory.trace 1, head, InternalHelpers.vars_hash_of(head)
            begin
              body.prove { 
                yield 
              }
            rescue RuleCut
            end
            Rubylog.current_theory.trace -1
          }
        end
      rescue PredicateCut
      end
    end

    def discontiguous!
      @discontiguous = true
    end

    def discontiguous?
      @discontiguous
    end

  end
  


end
