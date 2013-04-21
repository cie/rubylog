module Kernel
  def Rubylog &block
    if block
      ::Rubylog.amend &block
    else
      ::Rubylog
    end
  end
end
