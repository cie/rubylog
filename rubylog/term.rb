module Rubylog
  module Term
    def rubylog_clone
      yield self
    end

    def rubylog_variables
      []
    end

  end



end
