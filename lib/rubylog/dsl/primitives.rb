module Rubylog
  class DSL::Primitives
    def initialize context, subject=nil
      @context = context
      @subject = subject

      singleton_class = class << self; self; end
      primitives = self

      singleton_class.define_singleton_method :prefix do |*functors|
        functors.flatten.each do |fct|
          Context.send :define_method, fct do |_,*args|
            primitives.send(fct, *args) { yield }
          end
        end
      end

    end


    def singleton_method_added name
      unless name == :singleton_method_added
        m = method(name)

        predicate = Rubylog::Primitive.new(name, m)

        # nullary predicate
        if m.arity.zero?
          Rubylog::NullaryPredicates[name] = predicate
        else
          if @subject
            predicate.functor_for(@subject)
          else
            # use the default subject
            predicate.functor_for(@context.default_subject)
          end
        end
      end
    end

    def inspect
      "primitives"
    end
  end
end
