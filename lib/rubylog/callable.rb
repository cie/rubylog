module Rubylog
  module Callable
    # should yield for each possible solution of the term
    #def prove
    #  raise "abstract method called"
    #end

    # should return a Clause that serves as a human-and-computer-readable proof
    # of the statement
    #def proof
    #  raise "abstract method called"
    #end

    def true?
      Rubylog.current_theory.true? self
    end

    def solve
      if block_given?
        Rubylog.current_theory.solve(self) {|*a| yield *a}
      else
        Rubylog.current_theory.solve(self) {|*a|}
      end
    end
  end
end
