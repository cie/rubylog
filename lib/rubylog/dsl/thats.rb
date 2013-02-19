class Rubylog::DSL::Thats < BasicObject
  def method_missing *msg
    @messages ||= []
    @messages << msg
    self
  end

  def rubylog_matches_as_guard? other
    @messages.inject(other) {|o,msg|o.send *msg}
  end
  
  def == *msg
    method_missing :==, *msg
  end
end
