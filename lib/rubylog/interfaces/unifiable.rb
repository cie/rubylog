module Rubylog::Unifiable
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

  def rubylog_deep_dereference
    self
  end

  def rubylog_compile_variables
    self
  end
end
