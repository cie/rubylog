module Rubylog::TheoryModules
  module Primitives
    def clear
      @primitives = Rubylog::DSL::Primitives.new self
      super
    end

    def primitives
      @primitives
    end
    private :primitives
  end
end
