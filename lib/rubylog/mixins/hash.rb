class Hash
  include Rubylog::Term
  def rubylog_unify other
    return super{yield} unless other.instance_of? self.class
    if empty?
      old = 
    end
    (keys+other.keys).uniq.each do
      
    end
  end
end
