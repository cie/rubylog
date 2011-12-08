module Rubylog
  class Variable

    # data structure

    attr_reader :name, :assigned
    def initialize name
      @name = name
      @assigned = false
      @dont_care = !!(name.to_s =~ /^ANY/)
    end

    def inspect
      @name.to_s
    end

    def value
      return nil if (val = rubylog_dereference).kind_of? Variable
      val
    end

    def dont_care? 
      @dont_care
    end

    # Term methods
    
    include Term
    def rubylog_compile_variables vars=[], vars_by_name={}
      if dont_care?
        dup
      else
        unless (result = vars_by_name[@name])
          vars << (result = vars_by_name[@name] = dup)
        end
        result
      end
    end

    def rubylog_variables
      [self]
    end

    # Unifiable methods
    include Unifiable

    def rubylog_unify other
      if @assigned
        rubylog_dereference.rubylog_unify(other) do yield end
      else
        begin
          @assigned = true; @value = other
          yield
        ensure
          @assigned = false
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

    # Callable methods
    include Callable

    def prove
      # XXX not tested
      v = value
      raise InstantiationError if v.nil?
      v.prove{yield}
    end

  end


end
