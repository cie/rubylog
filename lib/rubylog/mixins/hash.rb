class Hash
  def rubylog_matches_as_guard? other
    self.each_pair do |k,v|
      return false unless v.rubylog_matches_as_guard? other.send(*k)
    end
    true
  end
end
