module Kernel
  def Rubylog &block
    if block
      ::Rubylog.instance_exec &block
    else
      ::Rubylog
    end
  end
end
