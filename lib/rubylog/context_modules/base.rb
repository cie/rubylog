module Rubylog::ContextModules
  module Base
    # calls initialize_context and calls super
    def initialize
      initialize_context
      super
    end

    # Clear all data in the context and bring it to its initial state.
    def initialize_context
      clear
    end

    def clear
      # included modules override this
    end
  end
end
