class Hash
  def rubylog_matches_as_guard? other
    self.each_pair do |k,v|
      return false unless v === other.send(k)
    end
    true
  end
end
