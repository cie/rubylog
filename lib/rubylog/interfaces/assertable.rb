module Rubylog::Assertable
  def if body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    theory.assert self, body || block
  end

  def if! body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    theory.assert self, Rubylog::Structure.new(theory, :and, :cut!, body || block)
  end

  def unless body=nil, &block
    raise Rubylog::SyntaxError, "No body given", caller unless body || block
    theory.assert self, Rubylog::Structure.new(theory, :false, body || block)
  end
end
