module Rubylog::TheoryModules
  module Base
    # calls initialize_theory and calls super
    def initialize
      initialize_theory
      super
    end

    # Clear all data in the theory and bring it to its initial state.
    def initialize_theory
      clear
    end

    def clear
      # included modules override this
    end
  end
end
