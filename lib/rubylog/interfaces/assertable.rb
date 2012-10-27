module Rubylog::Assertable
  def if body=nil, &block
    Rubylog.current_theory.assert self, body || block
  end

  def iff body=nil, &block
    Rubylog.current_theory.assert self, Rubylog::Structure.new(:and, :cut!, body || block)
  end

  def unless body=nil, &block
    Rubylog.current_theory.assert self, Rubylog::Structure.new(:false, body || block)
  end
end
