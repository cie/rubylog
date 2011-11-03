class Proc
  include ::Rubylog::Term

  attr_accessor :context_variables

  def prove
    if arity == -1
      yield if call *@context_variables.map{|v|v.value}
    else
      yield if call *@context_variables[0...arity].map{|v|v.value}
    end
  end
end
