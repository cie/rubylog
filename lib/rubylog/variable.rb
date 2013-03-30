module Rubylog
  class Variable

    # data structure

    attr_reader :name
    def initialize name = :"_#{object_id}"
      @name = name 
      @bound = false
      @dont_care = !!(name.to_s =~ /^(?:ANY|_)/i)
      @guards = []
    end

    def bound?
      @bound
    end

    def inspect
      if @guards.empty?
        @name.to_s
      else
        "#{@name}#{@guards}"
      end
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

    # unify two variables
    def rubylog_unify other
      # check if we are bound
      if @bound
        # if we are bound
        # proceed to our dereferenced value
        rubylog_dereference.rubylog_unify(other) do yield end
      else
        # if we are unbound
        
        # dereference the other
        other = other.rubylog_dereference

        # if the other is a variable
        if other.is_a? Rubylog::Variable
          # we union our guards with the other's
          other.append_guards guards do
            bind_to other do
              yield
            end
          end
        else
          # if the other is a value
          # bind to it and 
          bind_to other do
            # check our guards
            if guards.all? {|g|g.rubylog_matches_as_guard? other}
              yield
            end
          end
        end
      end
    end


    def rubylog_dereference
      if @bound
        @value.rubylog_dereference
      else
        self
      end
    end

    def rubylog_deep_dereference
      if @bound
        @value.rubylog_deep_dereference
      else
        self
      end
    end

    # Callable methods
    include Callable

    def prove
      v = value
      raise Rubylog::InstantiationError.new(self) if v.nil?

      # compile if not compiled
      if !v.rubylog_variables
        v = v.rubylog_compile_variables
      end
      
      v.prove{yield}
    end


    # Array splats
    def to_a
      [Rubylog::DSL::ArraySplat.new(self)]
    end
    alias to_ary to_a

    # String variables
    def to_s
      if @guards.empty?
        "#{String::RUBYLOG_VAR_START}#{@name}[]#{String::RUBYLOG_VAR_END}"
      else
        String::RubylogStringVariableGuards << @guards
        guard_index = String::RubylogStringVariableGuards.length-1
        "#{String::RUBYLOG_VAR_START}#{@name}[#{guard_index}]#{String::RUBYLOG_VAR_END}"
      end
    end

    # guards
    def [] *guards
      @guards += guards
      self
    end

    attr_reader :guards
    attr_writer :guards


    protected

    # yields with self bound to the given value
    def bind_to other
      begin
        @bound = true; @value = other
        Rubylog.print_trace 1, "#{inspect}=#{@value.inspect}"

        yield

      ensure
        @bound = false
        Rubylog.print_trace -1
      end
    end

    # yields with self.guards = self.guards + other_guards, then restores guards
    def append_guards other_guards
      original_guards = @guards

      @guards = @guards + other_guards

      begin
        yield
      ensure
        @guards = original_guards
      end
    end



  end


end
