module Rubylog
  class Theory
    def self.new! 
      Rubylog.theory = new
    end

    def initialize
      @database ||= Database.new
      @builtins = Object.new.extend Builtins
    end

    attr_reader :database

    def assert head, body=:true
      database << Clause.new(:-, head, body)
    end

    def prove? goal
      solve(goal) { return true }
      false
    end

    def solve goal
      case goal
      when Symbol
        Builtins.send(goal) { yield *variables }
      when Clause
        database[goal.desc].each do |rule|
          head, body = rule[0], rule[1]
          head.unify goal do
            solve(body) { yield *variables }
          end
        end
      when Proc
        case goal.arity
        when 0
          goal[]
        else
          goal[*variables]
        end
      else
        raise ArgumentError.new(goal)
      end
    end

    def variables
      [] # TODO
    end
  end
end
