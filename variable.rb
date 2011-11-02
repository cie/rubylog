module Rubylog
  class Variable
    include Term
    
    attr_reader :name, :assigned
    def initialize name
      @name = name
      @assigned = false
    end

    def inspect
      @name
    end

    def value
      dereference
    end
  end

  class DontCareVariable < Variable
  end

  module Term
  end

  class Clause
    attr_reader :rubylog_variables

    def variable_values
      rubylog_variables.map{|v|v.value}
    end

    def compile_variables! vars=[], vars_by_name={}
      return self if @variables_compiled
      @args.enum_with_index do |arg,i|
        case arg
        when Variable
          unless arg.kind_of? DontCareVariable
            if not (real_var = vars_by_name[arg.name])
              vars << (real_var = vars_by_name[arg.name] = arg)
            end
            @args[i] = real_var
          end
        when Clause
          arg.compile_variables! vars, vars_by_name
        end
      end
      @rubylog_variables = vars
      @variables_compiled = true
      self
    end
  end
end
