class Proc

  # Callable methods
  include Rubylog::Callable

  def prove
    yield if call_with_rubylog_variables
  end

  # CompositeTerm methods
  include Rubylog::CompositeTerm
  def rubylog_clone 
    yield dup
  end



  # Term methods
  def rubylog_resolve_function
    call_with_rubylog_variables
  end

  def call_with_rubylog_variables vars = nil
    vars ||= @rubylog_variables
    raise Rubylog::InvalidStateError, "Rubylog variables not available" if not vars

    Rubylog::ContextModules::DynamicMode.with_vars vars do
      return call
    end
    # to pass arguments:
    #if arity == -1
    #  call *@rubylog_variables.map{|v|v.value}
    #else
    #  call *@rubylog_variables[0...arity].map{|v|v.value}
    #end
  end
end
