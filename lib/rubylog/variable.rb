module Rubylog
  class Variable

    # data structure

    attr_reader :name
    def initialize name = :"_#{object_id}"
      @name = name 
      @assigned = false
      @dont_care = !!(name.to_s =~ /^(?:ANY|_)/i)
    end

    def assigned?
      @assigned
    end

    def inspect
      @name.to_s
    end

    def to_s
      @name.to_s
    end

    def == other
      Variable === other and @name == other.name
    end

    def eql? other
      Variable === other and @name == other.name
    end



    def value
      return nil if (val = rubylog_dereference).kind_of? Variable
      val
    end

    def dont_care? 
      @dont_care
    end

    # Term methods

    # rubylog_clone stays as is
    
    def rubylog_variables
      [self]
    end

    def rubylog_unify other
      if @assigned
        rubylog_dereference.rubylog_unify(other) do yield end
      else
        begin
          @assigned = true; @value = other
          Rubylog.current_theory.print_trace 1, "#{inspect}=#{@value.inspect}"
          yield
        ensure
          @assigned = false
          Rubylog.current_theory.print_trace -1
        end
      end
    end

    def rubylog_dereference
      if @assigned
        @value.rubylog_dereference
      else
        self
      end
    end

    def rubylog_deep_dereference
      if @assigned
        @value.rubylog_deep_dereference
      else
        self
      end
    end

    # Callable methods
    include Callable

    def prove
      v = value
      raise InstantiationError, self if v.nil?
      v.prove{yield}
    end


    # Array splats
    def to_a
      [Rubylog::DSL::ArraySplat.new(self)]
    end

  end


end
