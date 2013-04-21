class Object
  include Rubylog::Term

  def rubylog_matches_as_guard? other
    self === other
  end

  rubylog_traceable :rubylog_matches_as_guard?
end
