module Rubylog
  module DSL
    module Constants
      def self.included class_or_module
        class_or_module.extend ClassMethods
      end

      module ClassMethods
        def const_missing c
          Rubylog::Variable.new c
        end
      end
    end
  end
end
