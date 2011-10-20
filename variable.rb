module Rubylog
  class Variable
    include Term
    
    def initialize name
      @name = name
      @assigned = false
    end

    def inspect
      @name
    end
  end

  class DontCareVariable < Variable
  end
end
