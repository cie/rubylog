
module Rubylog
  module Unifiable
    def rubylog_unify other
      if other.kind_of? Rubylog::Variable
        other.rubylog_unify(self) do yield end
      else
        yield if self == other
      end
    end

    def rubylog_dereference
      self
    end
  end

  class Variable
    def rubylog_unify other
      if @assigned
        rubylog_dereference.rubylog_unify(other) do yield end
      else
        begin
          @assigned = true; @value = other
          yield
        ensure
          @assigned = false
        end
      end
    end

    def rubylog_dereference
      if @assigned
        @value.rubylog_dereference
      else
        self
      end
    end
  end


end
