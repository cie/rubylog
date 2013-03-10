module Rubylog::TheoryModules
  module Checks
    def clear
      @check_number = 0
      super
    end

    def check_passed goal
      print "#{n = check_number} :)\t"
    end

    def check_failed goal
      puts "#{check_number} :/\t"
      puts "Check failed: #{goal.inspect}"
      puts caller[1]
      #raise Rubylog::CheckFailed, goal.inspect, caller[1..-1]
    end

    def check_raised_exception goal, exception
      puts "#{check_number} :(\t"
      puts "Check raised exception: #{exception}"
      puts exception.backtrace
    end

    # returns the line number of the most recen +check+ call
    def check_number
      i = caller.index{|l| l.end_with? "in `check'" }
      caller[i+1] =~ /:(\d+):/
        $1
    end
    private :check_number

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
