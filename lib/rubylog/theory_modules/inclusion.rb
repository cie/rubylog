module Rubylog::TheoryModules
  module Inclusion
    attr_reader :included_theories

    def clear
      # this is done before super so that Builtins#clear can call
      # include_theory no matter if it is included before or after Inclusion
      @included_theories = []

      super
    end

    def include_theory *theories
      theories.each do |theory|

        @included_theories << theory

        # include all public_interface predicates
        @public_interface.send :include, theory.public_interface
        theory.each_pair do |indicator, predicate|
          if keys.include? indicator and self[indicator].respond_to? :multitheory? and self[indicator].multitheory?
            raise TypeError, "You can only use a procedure as a multitheory predicate (#{indicator})" unless predicate.respond_to? :each
            predicate.each do |rule|
              @database[indicator].assertz rule
            end
          else
            @database[indicator] = predicate
          end
        end

        # include prefix_functors
        theory.prefix_functor_modules.each do |m|
          @prefix_functor_modules << m
          extend m
        end

      end
    end

  end
end
