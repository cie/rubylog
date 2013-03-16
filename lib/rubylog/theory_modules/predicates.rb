require 'rubylog/simple_procedure'

require 'rubylog/dsl/functors'

module Rubylog::TheoryModules
  module Predicates

    attr_reader :public_interface
    attr_reader :prefix_functor_modules

    attr_accessor :last_predicate


    def clear
      @database = {}
      @public_interface = Module.new
      @subjects = []
      @check_discontiguous = true
      @prefix_functor_modules = []
      @last_predicate = nil
      super 
    end

    def [] indicator
      @database[Rubylog::DSL::Functors.unhumanize_indicator(indicator)]
    end

    def []= indicator, predicate
      @database[Rubylog::DSL::Functors.unhumanize_indicator(indicator)] = predicate
    end

    def keys
      @database.keys
    end

    def each_pair
      if block_given?
        @database.each_pair {|*a| yield *a }
      else
        @database.each_pair
      end
    end

    # directives
    #
    def predicate *indicators
      indicators.each do |indicator|
        indicator = Rubylog::DSL::Functors.unhumanize_indicator(indicator)
        create_procedure indicator
      end
    end

    def discontiguous *indicators
      indicators.each do |indicator|
        indicator = Rubylog::DSL::Functors.unhumanize_indicator(indicator)
        create_procedure(indicator).discontiguous!
      end
    end

    def check_discontiguous value = true
      @check_discontiguous = value
    end

    def check_discontiguous?
      @check_discontiguous
    end

    def multitheory *indicators
      indicators.each do |indicator|
        indicator = Rubylog::DSL::Functors.unhumanize_indicator(indicator)
        create_procedure(indicator).multitheory!
      end
    end

    def functor *functors
      functors.each do |fct|
        Rubylog::DSL::Functors.add_functors_to @public_interface, fct
        @subjects.each do |s|
          Rubylog::DSL::Functors.add_functors_to s, fct
        end
      end
    end

    def prefix_functor *functors
      functors.each do |fct|
        m = Module.new
        Rubylog::DSL::Functors.add_prefix_functors_to m, fct
        @prefix_functor_modules << m
        extend m
      end
    end

    def functor_for target, *functors
      functors.each do |fct|
        Rubylog::DSL::Functors.add_functors_to target, fct
      end
    end

    def private *indicators
    end

    def subject *subjects
      subjects.each do |s|
        s.send :include, @public_interface
        @subjects << s
      end
    end

    # predicates

    def assert head, body=:true
      indicator = head.indicator
      predicate = @database[indicator]
      if predicate
        check_assertable predicate, head, body
        check_not_discontiguous predicate, head, body
      else
        predicate = create_procedure indicator
      end
      predicate.assertz Rubylog::Structure.new(:-, head, body)
      @last_predicate = predicate
    end

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
          rule_head = rule[0]
          head.rubylog_unify rule_head do
            index = i
            result = rule
            throw :retract
          end
        end
        return nil
      end

    end

    protected

    def check_exists predicate, head
      raise Rubylog::ExistenceError.new(head.indicator) unless predicate
    end

    def check_not_discontiguous predicate, head, body
      raise Rubylog::DiscontiguousPredicateError.new(head.indicator) if check_discontiguous? and not predicate.empty? and predicate != @last_predicate and not predicate.discontiguous?
    end

    def check_assertable predicate, head, body
      raise Rubylog::NonAssertableError.new(head.indicator) unless predicate.respond_to? :assertz
    end

    def create_procedure indicator
      functor indicator[0]
      @database[indicator] = Rubylog::SimpleProcedure.new
    end


  end
end

