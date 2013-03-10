module Rubylog::TheoryModules
  module StaticMode
    def with_static_current_theory
      with_current_theory do
        yield
      end
    end

    def amend &block
      with_static_current_theory do
        with_implicit do
          return instance_exec &block
        end
      end
    end

  end
end

