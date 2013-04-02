module Rubylog
  class Primitive < Predicate

    def initialize callable
      @callable = callable
    end

    # calls the callable with the argumens
    def call *args
      @callable.call(*args) { yield }
    end

  end
end
