module Rubylog::TheoryModules
  module Tracing

    def clear
      @trace = false
      super
    end

    # debugging
    #
    #
    def trace val=true, &block
      @trace=block || val
      @trace_levels = 0
    end

    def print_trace level, *args
      return unless @trace
      if @trace.respond_to? :call
        @trace.call @trace_levels, *args if not args.empty?
      else
        if not args.empty?
          puts "  "*@trace_levels + args.map{|a|a.rubylog_deep_dereference.to_s}.join(" ") 
        else
          puts "  "*(@trace_levels-1) + "*"
        end
      end
      @trace_levels += level
    end
  end
end
