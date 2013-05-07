class Proc

  # Goal methods
  include Rubylog::Goal

  def prove
    yield if call_with_rubylog_variables
  end

  # CompoundTerm methods
  include Rubylog::CompoundTerm
  def rubylog_clone 
    yield dup
  end



  # Term methods
  def rubylog_resolve_function
    call_with_rubylog_variables
  end

  # Calls the proc with the given rubylog variables or with the currently
  # available variables.
  def call_with_rubylog_variables vars = nil
    vars ||= @rubylog_variables
    raise Rubylog::InvalidStateError, "Variables not matched" if not vars

    # Call the block with the variables substituted
    Rubylog::DSL::Variables.with_vars vars do
      return call
    end
  end
end
