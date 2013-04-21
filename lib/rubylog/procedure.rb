module Rubylog
  class Procedure < Predicate
    include Enumerable

    # accepts the *args of the called structure
    def call *args
      # catch cuts
      catch :cut do

        # for each rule
        each do |rule|
          # compile
          rule = rule.rubylog_compile_variables

          # unify the head with the arguments
          rule.head.args.rubylog_unify(args) do
            # call the body
            rule.body.prove do
              yield 
            end
          end
        end
      end
    end
    rubylog_traceable :call

    def each
      raise "abstract method called"
    end

    # Asserts a rule with a given head and body.
    def assert head, body=:true
      push Rubylog::Rule.new(head, body)
    end

  end
end
