module Kernel
  # Calls the given block within the default Rubylog context (::Rubylog)
  def rubylog &block
    Rubylog::DefaultContext.class_exec &block
  end
end
