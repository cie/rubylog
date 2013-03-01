module Rubylog::Callable
  # Clients should implement this method. 
  # Yields for each possible solution of the predicate
  def prove
    raise "#{self.class} should implement #prove"
  end

  def true?
    Rubylog.static_current_theory.true? self
  end

  def solve
    if block_given?
      Rubylog.static_current_theory.solve(self) {|*a| yield *a}
    else
      Rubylog.static_current_theory.solve(self) {|*a|}
    end
  end
end
