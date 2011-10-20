
module Rubylog
  module Term
    def unify other
      if other.kind_of? Rubylog::Variable
        other.unify(self) do yield end
      else
        yield if self == other
      end
    end

    def dereference
      self
    end

  end

  class Variable
    def unify other
      if @assigned
        dereference.unify(other) do yield end
      else
        @assigned = true; @value = other
        yield
        @assigned = false
      end
    end

    def dereference
      if @assigned
        @value.dereference
      else
        self
      end
    end
  end

  class Clause
    def unify other
      if other.kind_of? Clause and 
        if other.functor == functor
          args = @args
          other_args = other.args
          if args.count == other_args.count
            block = proc do
              if args.any?
                args.shift.unify(other_args.shift, &block)
              else
                yield
              end
            end
            block[]
          end
        end
      end
    end
  end

end
