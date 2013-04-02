require 'rubylog/simple_procedure'
require 'rubylog/rule'


module Rubylog
  module ContextModules
    module Predicates

      attr_reader :public_interface
      attr_reader :prefix_functor_modules

      attr_accessor :last_predicate


      def clear
        @public_interface = Module.new
        @default_subject = []
        @check_discontiguous = true
        @prefix_functor_modules = []
        @last_predicate = nil
        super 
      end



      

      # directives
      #
      def predicate *indicators
        each_indicator(indicators) do |indicator|
          create_procedure(indicator).functor_for [@default_subject, Variable]
        end
      end

      def predicate_for subjects, *indicators
        each_indicator(indicators) do |indicator|
          create_procedure(indicator).functor_for [subjects, Variable]
        end
      end

      def functor *functors
        functors.flatten.each do |fct|
          add_functors_to @public_interface, fct
          [@default_subject].flatten.each do |s|
            add_functors_to s, fct
          end
        end
      end

      def prefix_functor predicate
        m = Module.new
        f = predicate.functor

        m.class_eval do
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

        @prefix_functor_modules << m
        extend m
      end

      def private *indicators
        raise "not implemented"
      end

      attr_accessor :default_subject

      # predicates


      def retract head
        indicator = head.indicator
        predicate = @database[indicator]
        check_exists predicate, head
        check_assertable predicate, head, body

        head = head.rubylog_compile_variables

        index = nil
        result = nil
        catch :retract do
          predicate.each_with_index do |rule, i|
            head.rubylog_unify rule.head do
              index = i
              result = rule
              throw :retract
            end
          end
          return nil
        end

      end

      def create_procedure indicator
        Rubylog::SimpleProcedure.new indicator[0], indicator[1]
      end


      protected

      def check_exists predicate, head
        raise Rubylog::ExistenceError.new(self, head.indicator) unless predicate
      end

      def check_not_discontiguous predicate, head, body
        raise Rubylog::DiscontiguousPredicateError.new(self, head.indicator) if check_discontiguous? and not predicate.empty? and predicate != @last_predicate and not predicate.discontiguous?
      end

      def check_assertable predicate, head, body
        raise Rubylog::NonAssertableError.new(self, head.indicator) unless predicate.respond_to? :assertz
      end

      def check_modules modules
        modules.each do |m|
          raise ArgumentError, "#{m.inspect} is not a class or module",  caller[1..-1] unless m.is_a? Module
        end
      end

      def each_indicator indicators
        # TODO check if not empty
        #
        indicators.
          flatten.
          map{|str|str.split(" ")}.
          flatten.
          map{|i| unhumanize_indicator(i)}.
          each {|i| yield i }
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
end

