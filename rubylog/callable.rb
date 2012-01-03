module Rubylog
  module Callable
    # should yield for each possible solution of the term
    #def prove
    #  raise "abstract method called"
    #end

    def true?
      Rubylog.theory.true? self
    end

    def solve
      if block_given?
        Rubylog.theory.solve(self) {|*a| yield *a}
      else
        Rubylog.theory.solve(self) {|*a|}
      end
    end
  end
end
