#!/usr/bin/env ruby
# These are the rubylog transcripts of prolog codes from Roman Barták's Prolog
# guide: http://kti.mff.cuni.cz/~bartak/prolog/

require 'rubylog'

class << Rubylog.theory

  describe "How does it work?" do

    specify "declarative character" do
      (1.in? [1,2,3]).should be_true
      (X.in [1,2,3]).to_a.should == [1,2,3]
      (1.in [X,Y]).to_a.should == [[1,nil], [nil,1]]
      lists = []
      (1.in L).each do |l|
        lists << l
        break if lists.size == 3
      end
      #lists.should == [[1], [nil,1], [nil,nil,1]]
    end
  end

end

