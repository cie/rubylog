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

    def rubylog_variables_hash
      vars = rubylog_variables
      Hash[vars.zip(vars.map{|v|v.value})]
    end

  end



end
