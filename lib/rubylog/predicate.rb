
module Rubylog
  class Predicate < Array
    # accepts the *args of the called clause
    def call *args
      catch :cut do
        each do |rule|
          rule = rule.rubylog_compile_variables
          head, body = rule[0], rule[1]
          head.args.rubylog_unify(args) { 
            begin
              Rubylog.current_theory.print_trace 1, head, InternalHelpers.vars_hash_of(head)
              body.prove { 
                yield 
              }
            ensure
              Rubylog.current_theory.print_trace -1
            end
          }
        end
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
