module Rubylog::ContextModules
  module Builtins
    attr_accessor :base_context

    def clear
      super
      include_context base_context if base_context
    end
  end
end
