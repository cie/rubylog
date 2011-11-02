
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
        begin
          @assigned = true; @value = other
          yield
        ensure
          @assigned = false
        end
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
          my_args = @args.dup
          other_args = other.args.dup
          if my_args.count == other_args.count
            block = proc do
              if my_args.any?
                my_args.shift.unify(other_args.shift, &block)
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
