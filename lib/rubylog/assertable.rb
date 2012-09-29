module Rubylog
  module Assertable
    def if body=nil, &block
      Rubylog.current_theory.assert self, body || block
    end

    def unless body=nil, &block
      Rubylog.current_theory.assert self, Clause.new(:is_false, body || block)
    end
  end
end
