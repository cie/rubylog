module Rubylog
  class Cut < StandardError
  end

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

    def solve goal
      with_vars_of goal.compile_variables! do
        prove(goal) do
          yield(*goal.variable_values)
        end
      end
    end

    def true? goal
      with_vars_of goal.compile_variables! do
        prove(goal) do
          return true
        end
      end
      false
    end

    def prove goal
      case goal
      when Symbol, Clause
        if is_builtin? goal.functor
          Builtins.send(goal.functor, *goal.args) { yield }
        else
          begin
            database[goal.desc].each do |rule|
              with_vars_of rule do
                head, body = rule[0], rule[1]
                head.unify goal do
                  prove(body) { yield }
                end
              end
            end
          rescue Cut
          end
        end
      when Proc
        yield if run_proc &goal
      else
        raise ArgumentError.new(goal.inspect)
      end
    end

    def is_builtin? functor
      Builtins.respond_to? functor
    end

    def run_proc &block
      if block.arity == -1
        block[*@variable_bindings.last.map{|v|v.value}]
      else
        block[*@variable_bindings.last[0...block.arity].map{|v|v.value} ]
      end
    end

    def with_vars_of term
      begin
        @variable_bindings << term.rubylog_variables if term
        yield
      ensure
        @variable_bindings.pop if term
      end
    end

  end
end






