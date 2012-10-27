module Rubylog::Procedure
  include Rubylog::Predicate

  # accepts the *args of the called structure
  def call *args
    catch :cut do
      each do |rule|
        rule = rule.rubylog_compile_variables
        head, body = rule[0], rule[1]
        head.args.rubylog_unify(args) { 
          begin
            Rubylog.current_theory.print_trace 1, head, head.rubylog_variables_hash
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

  # In case of a procedure, `each` can be implemented, which should yield all
  # clauses. This makes reflection possible.
  # def each
  #   yield ...
  # end
  #
  # this should be implemented to enable assertions
  # def assertz clause
  #  ...
  # end
  #
  # def assertz clause
  #  ...
  # end
end
