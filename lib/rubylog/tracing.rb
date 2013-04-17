module Rubylog
  module Tracing
    # debugging
    #
    #
    def trace 
      old_trace = @trace
      @trace = true
      @trace_levels = 0
      begin
        return yield
      ensure
        @trace = old_trace
      end
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

  extend Tracing
end


