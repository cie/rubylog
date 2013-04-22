module Rubylog::ContextModules
  module Base
    # calls initialize_context and calls super
    def initialize
      initialize_context
      super
    end

    # Initializes the context
    #
    # We use this method instead of overriding initialize because often an
    # object becomes a context after having been initialized.
    def initialize_context
      # included modules override this
    end

  end
end
