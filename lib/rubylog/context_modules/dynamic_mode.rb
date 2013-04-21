module Rubylog::ContextModules
  module DynamicMode
    # Call the given block with variables automatically resolved
    def self.with_vars vars
      begin
        old_vars = Thread.current[:rubylog_current_variables]
        if old_vars
          Thread.current[:rubylog_current_variables] = old_vars + vars
        else
          Thread.current[:rubylog_current_variables] = vars
        end
        yield
      ensure
        Thread.current[:rubylog_current_variables] = old_vars
      end
    end
  end
end
