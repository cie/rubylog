
module Rubylog
  class Predicate < Array
    # accepts the *args of the called clause
    def call *args
      begin
        each do |rule|
          Rubylog.theory.with_vars_of rule do
            rule = rule.rubylog_compile_variables
            head, body = rule[0], rule[1]
            head.args.rubylog_unify(args) { body.prove { yield }}
          end
        end
      rescue Cut
      end
    end

  end
  


end
