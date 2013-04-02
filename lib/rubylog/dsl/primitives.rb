class Rubylog::DSL::Primitives
  def initialize theory, subject=nil
    @theory = theory
    @subject = subject
  end

  def singleton_method_added name
    unless name == :singleton_method_added
      m = method(name)

      # add functor
      unless m.arity.zero?
        if @subject
          @theory.predicate_for @subject, name
        else
          @theory.predicate name
        end
      end

      @theory[[name, m.arity]] = m
    end
  end

  def inspect
    "primitives"
  end
end
