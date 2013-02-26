module Rubylog::DSL::Variables
  def self.included mod
    def mod.const_missing c
      # different semantics in native blocks than otherwise
      # @see Proc#call_with_rubylog_variables
      if vars = Thread.current[:rubylog_current_variables]
        # in native blocks

        # find the appropriate variable name
        var = vars.find{|v|v.name == c}

        # return new variable if not found (probably the user wants to start using a new
        # one)
        return Rubylog::Variable.new c unless var

        # dereference it
        result = var.rubylog_deep_dereference

        # return nil if not bound
        return nil if result.is_a? Rubylog::Variable 

        # return the value
        result
      else
        Rubylog::Variable.new c
      end
    end
  end
end

