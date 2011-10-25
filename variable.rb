module Rubylog
  class Variable
    include Term
    
    attr_reader :name, :assigned, :value
    def initialize name
      @name = name
      @assigned = false
    end

    def inspect
      @name
    end
  end

  class DontCareVariable < Variable
  end

  class Clause
    def compile vars={}
      @args.enum_with_index do |a,i|
        case a
        when Variable
          @args[i] = vars[a.name] ||= a unless a.kind_of? DontCareVariable
        when Clause
          a.compile vars
        end
      end
      @variables = vars
      self
    end
  end
end
