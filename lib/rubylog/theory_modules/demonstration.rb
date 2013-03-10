module Rubylog::TheoryModules
  module Demonstration
    def solve goal, &block
      with_current_theory do
        goal = goal.rubylog_compile_variables 
        catch :cut do
          goal.prove { block.call_with_rubylog_variables(goal.rubylog_variables) if block }
        end
      end
    end

    def true? goal=nil, &block
      #if goal.nil? 
      #raise ArgumentError, "No goal given" if block.nil?
      #goal = with_current_theory &block
      #end

      with_current_theory do
        goal = goal.rubylog_compile_variables
        catch :cut do
          goal.prove { return true }
        end
      end
      false
    end

    alias prove true?

  end
end
