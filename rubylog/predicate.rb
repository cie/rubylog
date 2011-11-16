
module Rubylog
  class Predicate < Array
    def call
      begin
        each do |rule|
          Rubylog.theory.with_vars_of rule do
            rule = rule.rubylog_compile_variables
            head, body = rule.pop, rule
            head.unify { body.prove { yield }}
          end
        end
      rescue Cut
      end
    end

  end
  


end
