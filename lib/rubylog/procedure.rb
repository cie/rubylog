module Rubylog
  class Procedure < Predicate
    include Enumerable

    def initialize functor, arity, rules=Array.new
      super functor, arity
      @rules = rules
    end

    def inspect
      "#{Rubylog::DSL::Indicators.humanize_indicator([functor,arity])}: #{@rules.inspect}"
    end 

    def method_missing name, *args, &block
      @rules.send name, *args, &block
    end

    # accepts the *args of the called structure
    def call *args
      # catch cuts
      catch :rubylog_cut do

        # for each rule
        each do |rule|
          # compile
          rule = rule.rubylog_match_variables

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

    # Asserts a rule with a given head and body.
    def assert head, body=:true
      push Rubylog::Rule.new(head, body)
    end

  end
end
