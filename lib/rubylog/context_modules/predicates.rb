require 'rubylog/rule'
require 'rubylog/dsl/indicators'


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
          map{|i| Rubylog::DSL::Indicators.unhumanize_indicator(i)}.
          each {|i| yield i }
      end
    end
  end
end

