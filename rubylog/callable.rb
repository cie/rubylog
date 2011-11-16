module Rubylog
  module Callable
    def prove
      raise "abstract method called"
    end

    def true?
      Rubylog.theory.true? self
    end

    def solve
      Rubylog.theory.solve(self) {|*a| yield *a}
    end
  end
end
