module Rubylog::Procedure
  include Rubylog::Predicate

  # accepts the *args of the called structure
  def call *args
    catch :cut do
      each do |rule|
        begin
          rule = rule.rubylog_compile_variables
          Rubylog.print_trace 1, rule.head.args, "=", args
          rule.head.args.rubylog_unify(args) { 
            begin
              Rubylog.print_trace 1, rule.head, rule.head.rubylog_variables_hash
              rule.body.prove { 
                yield 
              }
            ensure
              Rubylog.print_trace -1
            end
          }
        ensure
          Rubylog.print_trace -1
        end
      end
    end
  end

  def discontiguous!
    @discontiguous = true
  end

  def discontiguous?
    @discontiguous
  end

  def multitheory!
    @multitheory = true
  end

  def multitheory?
    @multitheory
  end

  # In case of a procedure, `each` can be implemented, which should yield all
  # clauses. This makes reflection possible.
  #
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
