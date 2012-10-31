# this class is used as a placeholder for array splats.
# [*A] => [ArraySplat.new(A)]
class Rubylog::DSL::ArraySplat

  attr_reader :var

  def initialize var
    @var = var
  end
end
