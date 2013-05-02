class Class
  def rubylog_traceable name
    Rubylog.traceable instance_method(name)
  end
end

module Rubylog
  module Tracing
    attr_reader :traceable_methods
    attr_accessor :trace_levels

    # Turns trace on. If value is given and is false, turns trace off. If a
    # block is given, calls the block with trace on.
    #
    def trace value=true
      if not block_given?
        @trace = value
        @trace_levels = 0
        update_trace
      else
        begin
          trace
          return yield
        ensure
          trace false
        end
      end
    end

    # returns true if tracing is active
    def trace?
      @trace
    end


    def traceable method
      @traceable_methods ||= []
      @traceable_methods << method
    end

    private

    def update_trace
      if trace?
        traceable_methods.each do |m|
          m.owner.send :define_method, m.name do |*args,&block|
            begin
              print " "*Rubylog.trace_levels
              Rubylog.trace_levels += 1
              print "#{inspect}.#{m.name}(#{args.map{|k|k.inspect}.join(", ")})?"
              gets

              return m.bind(self).call *args, &block
            ensure
              Rubylog.trace_levels -= 1
              print " "*Rubylog.trace_levels
              print "*"
              puts
            end
          end
        end
      else
        traceable_methods.each do |m|
          m.owner.send :define_method, m.name do |*args, &block|
            m.bind(self).call(*args, &block)
          end
        end
      end

    end
  end
  extend Tracing
end


