class Proc

  def true?
    call_with_rubylog_variables
  end

  def prove
    yield if call_with_rubylog_variables
  end

  def solve
    Rubylog.theory.solve(self) {|*a| yield *a}
  end

  def call_with_rubylog_variables
    raise Rubylog::ArgumentError, "variables not available" if not @context_variables
    if arity == -1
      call *@context_variables.map{|v|v.value}
    else
      call *@context_variables[0...arity].map{|v|v.value}
    end
  end

  def rubylog_compile_variables vars=[], vars_by_name={}
    @context_variables = vars
    dup
  end
end
