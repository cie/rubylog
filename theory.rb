module Rubylog
  class Theory
    def self.new! 
      Rubylog.theory = new
    end

    def initialize
      @database ||= Database.new
      @variable_bindings = []
    end

    attr_reader :database

    def assert head, body=:true
      database << Clause.new(:-, head, body).compile_variables!
    end

    def prove? goal
      solve(goal) { return true }
      false
    end

    def solve goal
      case goal
      when Symbol
        Builtins.send(goal) { yield }
      when Clause
        if is_builtin? goal.functor
          Builtins.send(goal.functor, *goal.args) { yield }
        else
          database[goal.desc].each do |rule|
            begin
              @variable_bindings << rule.rubylog_variables
              head, body = rule[0], rule[1]
              head.unify goal do
                solve(body) { yield }
              end
            ensure
              @variable_bindings.pop
            end
          end
        end
      when Proc
        yield if goal[
          *@variable_bindings.last[0...goal.arity].map{|v|v.value}
        ]
      else
        debugger
        raise ArgumentError.new(goal.inspect)
      end
    end

    def is_builtin? functor
      Builtins.respond_to? functor
    end

  end
end
