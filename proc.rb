class Proc

  # Callable methods
  include Rubylog::Callable
  def prove
    yield if call_with_rubylog_variables
  end


  def call_with_rubylog_variables
    raise Rubylog::ArgumentError, "variables not available" if not @context_variables
    if arity == -1
      call *@rubylog_variables.map{|v|v.value}
    else
      call *@rubylog_variables[0...arity].map{|v|v.value}
    end
  end

  # CompositeTerm methods
  include Rubylog::CompositeTerm 
  def rubylog_cterm_compile_variables *_
    dup
  end

  # Unifiable methods
  include Rubylog::Unifiable
end
