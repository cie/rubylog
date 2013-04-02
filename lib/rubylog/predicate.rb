module Rubylog
  class Predicate

    attr_reader :functor, :arity
    def initialize functor, arity
      @functor = functor
      @arity = arity
    end

    # Yields for each solution of the predicate
    def call *args
      raise "abstract method called"
    end

    def functor_for subject
      predicate = self

      subject.class_eval do
        f = predicate.functor
        define_method f do |*args, &block|
        args << block if block
        Rubylog::Structure.new predicate, f, self, *args 
        end

        f_bang = :"#{f}!"
        define_method f_bang do |*args, &block|
        args << block if block
        predicate.assert Rubylog::Structure.new(predicate, f, self, *args), :true
        self
        end

        f_qmark = :"#{f}?"
        define_method f_qmark do |*args, &block|
        args << block if block
        Rubylog::Structure.new(predicate, f, self, *args).true?
        end
      end

    end

    def prefix_functor_in context
      context.class_eval do
        define_method f do |*args, &block|
        args << block if block
        Rubylog::Structure.new self, f, *args 
        end

        f_bang =  :"#{f}!"
        define_method f_bang do |*args, &block|
        args << block if block
        assert Rubylog::Structure.new(self, f, *args), :true
        nil
        end

        f_qmark = :"#{f}?"
        define_method f_qmark do |*args, &block|
        args << block if block
        Rubylog::Structure.new(self, f, *args).true?
        end
      end
    end


    # Makes human-friendly output from the indicator
    # For example, .and()
    def humanize_indicator indicator
      return indicator if String === indicator
      functor, arity, prefix = indicator
      if prefix
        if arity > 0
          "#{functor}(#{ ','*(arity-1) })"
        else
          "#{functor}"
        end
      else
        if arity > 1
          ".#{functor}(#{ ','*(arity-2) })"
        elsif arity == 1
          ".#{functor}"
        else
          ":#{functor}"
        end
      end
    end

    # Makes internal representation from predicate indicator
    #
    # For example, <tt>.and()</tt> becomes <tt>[:and,2]</tt>
    def unhumanize_indicator indicator
      case indicator
      when Array
        indicator
      when /\A:(\w+)\z/
        [:"#{$1}",0]
      when /\A\.(\w+)\z/
        [:"#{$1}",1]
      when /\A\.(\w+)\((,*)\)\z/
        [:"#{$1}",$2.length+2]
      when /\A(\w+)\z/
        [:"#{$1}",0,true]
      when /\A(\w+)\((,*)\)\z/
        [:"#{$1}",$2.length+1,true]
      else
        raise ArgumentError, "invalid indicator: #{indicator.inspect}"
      end

    end


  end
end
