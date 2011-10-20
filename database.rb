module Rubylog
  class Database
    def initialize
      @predicates = Hash.new{|hash,key|hash[key] = []}
    end

    def [] desc
      @predicates[desc]
    end

    def << clause
      @predicates[clause[0].desc] << clause
    end

  end

end
