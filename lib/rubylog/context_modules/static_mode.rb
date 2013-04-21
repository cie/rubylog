module Rubylog::ContextModules
  module StaticMode
    def amend &block
      with_implicit do
        return instance_exec &block
      end
    end

    alias query amend

  end
end

