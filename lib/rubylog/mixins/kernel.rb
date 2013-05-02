module Kernel
  # Calls the given block within the default Rubylog context (::Rubylog)
  def rubylog &block
    Rubylog::DefaultContext.instance_exec &block
  end
end
