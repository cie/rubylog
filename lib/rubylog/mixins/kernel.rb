module Kernel
  # Calls the given block within the default Rubylog context (::Rubylog)
  def Rubylog &block
    ::Rubylog.instance_exec &block
  end
end
