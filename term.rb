module Rubylog
  module Term

    class << self
      def included class_or_module
        Rubylog.used_classes << class_or_module
        class_or_module.extend ClassMethods
      end
    end

    module ClassMethods
    end

  end
end
