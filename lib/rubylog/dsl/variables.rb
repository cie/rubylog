module Rubylog::DSL::Variables
  def self.included mod
    def mod.const_missing c
      # different semantics in functions/callable procs than otherwise
      # @see Method#call_with_rubylog_variables
      if vars = Thread.current[:rubylog_current_variables] and var = vars.find{|v|v.name == c}
        var.rubylog_deep_dereference
      else
        Rubylog::Variable.new c
      end
    end
  end
end

