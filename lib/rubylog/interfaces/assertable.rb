module Rubylog::Assertable
  def if body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    Rubylog.static_current_theory.assert self, body || block
  end

  def if! body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    Rubylog.static_current_theory.assert self, Rubylog::Structure.new(:and, :cut!, body || block)
  end

  def unless body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    Rubylog.static_current_theory.assert self, Rubylog::Structure.new(:false, body || block)
  end
end
