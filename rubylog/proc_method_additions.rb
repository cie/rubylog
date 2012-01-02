module Rubylog
  module ProcMethodAdditions

    def self.included class_or_module
      class_or_module.send :include, Rubylog::Callable

      # procs and methods are composite terms, just to simply get
      # access to variables
      class_or_module.send :include, Rubylog::CompositeTerm
    end

    # Callable methods
    def prove
      yield if call_with_rubylog_variables
    end


    def call_with_rubylog_variables
      raise Rubylog::InvalidStateError, "variables not available" if not @rubylog_variables
      if arity == -1
        call *@rubylog_variables.map{|v|v.value}
      else
        call *@rubylog_variables[0...arity].map{|v|v.value}
      end
    end

    # CompositeTerm methods
    def rubylog_clone 
      yield dup
    end
  end
end

