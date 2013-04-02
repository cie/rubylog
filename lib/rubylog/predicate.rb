module Rubylog
  class Predicate

    def initialize name, arity
      @name = name
      @arity = arity
    end

    # Yields for each solution of the predicate
    def call *args
      raise "abstract method called"
    end



  end
end
