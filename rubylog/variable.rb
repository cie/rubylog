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
