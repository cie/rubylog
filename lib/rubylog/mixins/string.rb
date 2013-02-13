class String
  RUBYLOG_VAR_START = "\u0091" # "\u00ab"
  RUBYLOG_VAR_END   = "\u0092" # "\u00bb"
  RUBYLOG_VAR_REGEXP = /#{RUBYLOG_VAR_START}(.*?)#{RUBYLOG_VAR_END}/
  RUBYLOG_VAR_REGEXP_START = /\A#{RUBYLOG_VAR_START}(.*?)#{RUBYLOG_VAR_END}/
  RUBYLOG_VAR_REGEXP_ALL = /\A#{RUBYLOG_VAR_START}(.*?)#{RUBYLOG_VAR_END}\z/

  # Term methods
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class

    self_has_vars = self =~ RUBYLOG_VAR_REGEXP
    other_has_vars = other =~ RUBYLOG_VAR_REGEXP

    return super{yield} unless self_has_vars or other_has_vars
    raise Rubylog::InstantiationError, "Cannot unify two strings with variables inside" if self_has_vars and other_has_vars

    a, b = self_has_vars ? [self, other] : [other, self]
    
    if (m = a.rubylog_regexp.match b)
      a.rubylog_string_variables.rubylog_unify m.captures do
        yield
      end
    end
  end

  # CompositeTerm methods
  include Rubylog::CompositeTerm
  def rubylog_clone &block
    scan RUBYLOG_VAR_REGEXP do
      Rubylog::Variable.new($1.to_sym).rubylog_clone(&block)
    end
    block[self]
  end

  def rubylog_deep_dereference 
    gsub RUBYLOG_VAR_REGEXP do
      rubylog_get_string_variable($1).rubylog_deep_dereference.to_s
    end
  end

  def rubylog_regexp
    /\A#{Regexp.quote(self).gsub(RUBYLOG_VAR_REGEXP, "(.*?)")}\z/
  end

  def rubylog_string_variables
    scan(RUBYLOG_VAR_REGEXP).map do |x|
      rubylog_get_string_variable(x.first)
    end
  end

  protected

  def rubylog_get_string_variable s
    s = s.to_sym
    if @rubylog_variables
      @rubylog_variables.find{|v|v.name == s}
    else
      raise InvalidStateError, "Rubylog variables not available"
    end
  end

end
