module Rubylog
  class Variable
    include Term
    
    attr_reader :name, :assigned
    def initialize name
      @name = name
      @assigned = false
    end

    def inspect
      @name
    end

    def value
      dereference
    end
  end

  class DontCareVariable < Variable
  end

  module Term
  end

end
