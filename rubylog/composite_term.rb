module Rubylog
  module CompositeTerm
    def rubylog_compile_variables vars=[], vars_by_name={}
      result = rubylog_cterm_compile_variables vars, vars_by_name
      result.instance_variable_set :"@rubylog_variables", vars
      result
    end

    def rubylog_variables
      @rubylog_variables
    end

    # should return a deep copy of the object, with all sub-terms'
    # rubylog_compile_variables
    #def rubylog_cterm_compile_variables vars=[], vars_by_name={}
      #raise "abstract method called"
    #end
  end
end
