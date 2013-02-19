class String
  RUBYLOG_VAR_START = "\u0091" # "\u00ab"
  RUBYLOG_VAR_END   = "\u0092" # "\u00bb"
  RUBYLOG_VAR_REGEXP = /#{RUBYLOG_VAR_START}([^\[]+?)\[(.*?)\]#{RUBYLOG_VAR_END}/

  RubylogStringVariableGuards = [[]]

  def self.rubylog_unify_strings a, a_segments, a_vars, b
    #p a, a_segments, a_vars, b
    if a_segments.count == 1
      segment = a_segments[0]
      if b.end_with?(segment)
        #p b[0...b.length-segment.length]
        a_vars[0].rubylog_unify b[0...b.length-segment.length] do
          yield
        end
      end
    else
      b.scan /#{Regexp.quote(a_segments[0])}/ do
        a_vars[0].rubylog_unify(b[0...Regexp.last_match.begin(0)]) do
          rubylog_unify_strings(a, a_segments[1..-1], a_vars[1..-1], b[Regexp.last_match.end(0)..-1]) do
            yield
          end
        end
      end
    end
  end

  # Term methods
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class

    self_has_vars = self =~ RUBYLOG_VAR_REGEXP
    other_has_vars = other =~ RUBYLOG_VAR_REGEXP

    return super{yield} unless self_has_vars or other_has_vars
    raise Rubylog::InstantiationError, "Cannot unify two strings with variables inside" if self_has_vars and other_has_vars

    a, b = self_has_vars ? [self, other] : [other, self]
    a_segments, a_vars = a.rubylog_segments

    return unless b.start_with? a_segments[0]
    b = b[a_segments[0].length..-1]; a_segments.shift

    String.rubylog_unify_strings(a, a_segments, a_vars, b) do
      yield
    end

  end

  # CompositeTerm methods
  include Rubylog::CompositeTerm
  def rubylog_clone &block
    scan RUBYLOG_VAR_REGEXP do
      guards = RubylogStringVariableGuards[$2.to_i] 
      Rubylog::Variable.new($1.to_sym)[*guards].rubylog_clone(&block)
    end
    block[self]
  end

  def rubylog_deep_dereference 
    gsub RUBYLOG_VAR_REGEXP do
      rubylog_get_string_variable($1).rubylog_deep_dereference.to_s
    end
  end

  # returns a list of substrings which are before, between and after the rubylog
  # string variables
  def rubylog_segments
    segments = [[0]]
    vars = []

    scan RUBYLOG_VAR_REGEXP do
      match = Regexp.last_match
      #p match
      #p match.begin(0)
      #p match.end(0)
      #p match[0]
      #p match[1]
      segments.last << match.begin(0)
      segments << [match.end(0)]
      vars << rubylog_get_string_variable(match[1])
    end
    

    segments.last << length
    #p segments, vars
    segments = segments.map{|s|self[s[0]...s[1]]}
    #p [self, segments, vars]
    return segments, vars
  end

  protected

  def rubylog_get_string_variable s
    s = s.to_sym
    if @rubylog_variables
      @rubylog_variables.find{|v|v.name == s}
    else
      raise Rubylog::InvalidStateError, "Rubylog variables not available"
    end
  end

end
