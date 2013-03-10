module Rubylog::TheoryModules
  module Checks
    def check_passed goal
    end

    def check_failed goal
      raise Rubylog::CheckFailed.new(goal)
    end

    def check_raised_exception goal, exception
      raise exception
    end

    # Tries to prove goal (or block if goal is not given). If it proves, calles
    # +check_passed+. If it fails, calls +check_failed+. If it raises an exception, calls +check_raised_exception+.
    def check goal=nil, &block
      goal ||= block
      result = nil
      begin 
        result = true?(goal)
      rescue
        check_raised_exception goal, $!
      else
        if result
          check_passed goal, &block
        else
          check_failed goal, &block
        end
      end
      result
    end


  end
end
