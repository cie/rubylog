module Rubylog

  class Variable
    attr_reader :name, :assigned
    def initialize name
      @name = name
      @assigned = false
      @dont_care = !!(name.to_s =~ /^ANY/)
    end

    def inspect
      @name
    end

    def value
      return nil if (val = rubylog_dereference).kind_of? Variable
      val
    end

    def dont_care? 
      @dont_care
    end

    def rubylog_compile_variables vars=[], vars_by_name={}
      if dont_care?
        dup
      else
        unless (result = vars_by_name[@name])
          vars << (result = vars_by_name[@name] = dup)
        end
        result
      end
    end
  end

  module Term
    def rubylog_compile_variables
      self
    end

    def rubylog_variables
      []
    end

    def rubylog_variable_values
      rubylog_variables.map{|v|v.value}
    end
  end
end
