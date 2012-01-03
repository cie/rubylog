module Rubylog
  module Term
    def rubylog_clone
      yield self
    end

    def rubylog_variables
      []
    end

    def rubylog_resolve_function
      self
    end

  end



end
