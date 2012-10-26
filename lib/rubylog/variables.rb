-module Rubylog
-  module DSL
    module Variables
      def self.included class_or_module
        def class_or_module.const_missing c
          # different semantics in functions/callable procs than otherwise
          # @see ProcMethodAdditions#call_with_rubylog_variables
          if vars = Thread.current[:rubylog_current_variables] and var = vars.find{|v|v.name == c}
            var.rubylog_deep_dereference
          else
            Rubylog::Variable.new c
          end
        end
      end
    end
  end
end

