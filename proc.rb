class Proc
  include ::Rubylog::Term

  attr_accessor :context_variables

  def prove
    yield if call_with_variables
  end

  def call_with_variables
    raise Rubylog::ArgumentError, "Variables are not compiled" if not @context_variables
    if arity == -1
      call *@context_variables.map{|v|v.value}
    else
      call *@context_variables[0...arity].map{|v|v.value}
    end
  end
end
