require 'rubylog/rule'


module Rubylog
  module ContextModules
    module Predicates

      def predicate *indicators
        each_indicator(indicators) do |indicator|
          create_procedure(indicator).add_functor_to [default_subject, Variable]
        end
      end

      def predicate_for subjects, *indicators
        each_indicator(indicators) do |indicator|
          create_procedure(indicator).add_functor_to [subjects, Variable]
        end
      end

      def predicate_for_context *indicators
        each_indicator(indicators) do |indicator|
          create_procedure(indicator).add_functor_to ::Rubylog::Context
        end
      end

      attr_writer :default_subject
      def default_subject
        @default_subject || []
      end 


      protected

      def create_procedure indicator
        Rubylog::Procedure.new indicator[0], indicator[1]
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
        functor, arity = indicator
        if arity > 1
          ".#{functor}(#{ ','*(arity-2) })"
        elsif arity == 1
          ".#{functor}"
        elsif arity == 0
          ":#{functor}"
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
        when /\A\w*\.(\w+)\z/
          [:"#{$1}",1]
        when /\A\w*\.(\w+)\(\w*((,\w*)*)\)\z/
          [:"#{$1}",$2.count(",")+2]
        else
          raise ArgumentError, "invalid indicator: #{indicator.inspect}"
        end

      end

    end
  end
end

