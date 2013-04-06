module Rubylog
  class SimpleProcedure < Procedure
    def initialize functor, arity
      super
      @rules = []
    end

    def push rule
      @rules.push rule
    end

    def pop
      @rules.pop
    end

    def shift
      @rules.shift
    end

    def unshift rule
      @rules.unshift rule
    end

    def each
      @rules.each {|r| yield r}
    end

  end

end

