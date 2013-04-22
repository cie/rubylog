module Rubylog::Term
  def rubylog_clone
    yield self
  end

  def rubylog_variables
    []
  end

  def rubylog_resolve_function
    self
  end

  def rubylog_variables_hash
    vars = rubylog_variables
    Hash[vars.zip(vars.map{|v|v.value})]
  end

  def rubylog_unify other
    if other.kind_of? Rubylog::Variable
      other.rubylog_unify(self) do yield end
    else
      yield if self.eql? other
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



