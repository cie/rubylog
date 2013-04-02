module Rubylog
  class Procedure < Predicate
    include Enumerable

    # accepts the *args of the called structure
    def call *args
      # catch cuts
      catch :cut do

        # for each rule
        each do |rule|
          begin

            # compile
            rule = rule.rubylog_compile_variables
            Rubylog.print_trace 1, rule.head.args, "=", args

            # unify the head with the arguments
            rule.head.args.rubylog_unify(args) do
              begin
                Rubylog.print_trace 1, rule.head, rule.head.rubylog_variables_hash

                # call the body
                rule.body.prove do
                  yield 
                end
              ensure
                Rubylog.print_trace -1
              end
            end
          ensure
            Rubylog.print_trace -1
          end
        end
      end
    end

    # Asserts a rule with a given head and body.
    def assert head, body=:true
      indicator = head.indicator
      predicate = @database[indicator]
      check_exists predicate, head
      check_assertable predicate, head, body
      check_not_discontiguous predicate, head, body
      predicate.assertz Rubylog::Rule.new(head, body)
      @last_predicate = predicate
    end

    def discontiguous!
      @discontiguous = true
    end

    def discontiguous?
      @discontiguous
    end


    def each
      raise "abstract method called"
    end
  end
end
