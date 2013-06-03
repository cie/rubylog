module Kernel
  # Calls the given block within the default Rubylog context (::Rubylog)
  def rubylog &block
    Rubylog::DefaultContext.class_exec &block
  end

  # requires a Rublog file in a Rubylog context
  def load_rubylog_file filename, context=Rubylog::DefaultContext
    require "rubylog/rubylog_files"
    source = File.read(filename)
    source = Rubylog::RubylogFiles.convert_source(source)
    eval(source, TOPLEVEL_BINDING, filename, 1)
  end 
end
