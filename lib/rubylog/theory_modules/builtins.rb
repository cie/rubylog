module Rubylog::TheoryModules
  module Builtins
    attr_accessor :base_theory

    def clear
      super
      include_theory base_theory if base_theory
    end
  end
end
