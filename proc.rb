class Proc
  def prove
    yield if call
  end
end
