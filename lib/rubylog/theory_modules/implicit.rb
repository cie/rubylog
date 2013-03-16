module Rubylog::TheoryModules
  module Implicit

    def clear
      @implicit = false
      super
    end

    def with_implicit
      begin
        @with_implicit = true
        # start implicit mode
        if @implicit
          start_implicit
        end

        yield
      ensure
        @with_implicit = false
        # stop implicit mode
        if @implicit_started
          stop_implicit
        end
      end
    end

    def with_current_theory
      begin
        # save current theory
        old_theory = Thread.current[:rubylog_current_theory]
        Thread.current[:rubylog_current_theory] = self

        # call the block
        yield
      ensure 
        # restore current theory
        Thread.current[:rubylog_current_theory] = old_theory
      end
    end

    # Starts (if +val+ is not given or true) or stops (if +val+ is false) implicit mode.
    #
    # In implicit mode you can start using infix functors without declaring them.
    def implicit val=true
      @implicit = val

      if val
        if @with_implicit
          start_implicit
        end
      else
        if @implicit_started
          stop_implicit
        end
      end
    end
    def start_implicit
      theory = self
      [@public_interface, Rubylog::Variable].each do |m|
        m.send :define_method, :method_missing do |m, *args|
          fct = Rubylog::DSL::Functors.normalize_functor(m) 
          return super if fct.nil?
          raise NameError, "'#{fct}' method already exists" if respond_to? fct
          theory.functor fct
          self.class.send :include, Rubylog::DSL.functor_module(fct)
          send m, *args
        end
      end
      @implicit_started = true
    end

    def stop_implicit
      [@public_interface, Rubylog::Variable].each do |m|
        m.send :remove_method, :method_missing
      end
      @implicit_started = false
    end

  end
end
