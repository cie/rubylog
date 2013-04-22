module Rubylog::ContextModules
  module Inclusion
    attr_reader :included_contexts

    def clear
      # this is done before super so that Builtins#clear can call
      # include_context no matter if it is included before or after Inclusion
      @included_contexts = []

      super
    end

    def include_context *contexts
      contexts.each do |context|

        @included_contexts << context

      end
    end

  end
end
