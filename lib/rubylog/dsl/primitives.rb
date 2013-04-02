module Rubylog
  class DSL::Primitives
    def initialize context, subject=nil
      @context = context
      @subject = subject

      singleton_class = class << self; self; end
      primitives = self

      singleton_class.define_singleton_method :prefix do |*functors|
        functors.flatten.each do |fct|
          context.prefix_functor(Primitive.new(fct, primitives.method(fct)))
        end
      end

    end


    def singleton_method_added name
      unless name == :singleton_method_added
        m = method(name)

        # add functor
        unless m.arity.zero?
          if @subject
            @context.create_procedure([name, m.arity]).functor_for(@subject) # :indicator:
          else
            # use the default subject
            @context.predicate name
          end
        end
      end
    end

    def inspect
      "primitives"
    end
  end
end
