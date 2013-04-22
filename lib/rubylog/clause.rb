module Rubylog::Clause
  # Clients should implement this method. 
  # Yields for each possible solution of the predicate
  def prove
    raise "#{self.class} should implement #prove"
  end

  def true?
    solve { return true }
    false
  end

  def solve &block
    goal = rubylog_compile_variables 
    catch :cut do
      goal.prove { block.call_with_rubylog_variables(goal.rubylog_variables) if block }
    end
  end
end
