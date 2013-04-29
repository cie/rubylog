# this class is used as a placeholder for array splats.
# [*A] => [ArraySplat.new(A)]
class Rubylog::DSL::ArraySplat

  attr_reader :var

  def initialize var = Rubylog::Variable.new
    @var = var
  end

  def inspect
    "*#{var.inspect}"
  end

  def eql? other
    @var.eql? other.var
  end

  def == other
    @var == other.var
  end

  def hash
    @var.hash
  end

  # CompoundTerm methods
  include Rubylog::CompoundTerm

  def rubylog_clone &block
    block[Rubylog::DSL::ArraySplat.new(@var.rubylog_clone(&block))]
  end

  def rubylog_deep_dereference
    Rubylog::DSL::ArraySplat.new(@var.rubylog_deep_dereference)
  end
end
