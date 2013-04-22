module Rubylog::ContextModules
  module StaticMode
    def amend &block
      return instance_exec &block
    end

    alias query amend

  end
end

