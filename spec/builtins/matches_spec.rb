
      describe "matches" do
        before do
          :john.likes! "Beer"
          :jane.likes! "Water"
        end

        it "works for variables" do
          (A.likes(B).and(B.matches /e/)).to_a.should == [[:john, "Beer"], [:jane, "Water"]]
          (A.likes(B).and(B.matches /ee/)).to_a.should == [[:john, "Beer"]]
          (A.likes(B).and(B.matches /w/i)).to_a.should == [[:jane, "Water"]]
        end

        it "works as calculation" do
          (A.likes(B).and(B.matches {|a,b|/e/})).to_a.should == [[:john, "Beer"], [:jane, "Water"]]
          (A.likes(B).and(B.matches {|a,b|/ee/})).to_a.should == [[:john, "Beer"]]
          (A.likes(B).and(B.matches {|a,b|/w/i})).to_a.should == [[:jane, "Water"]]
          (A.likes(B).and(B.matches {|a,b|b})).to_a.should == [[:john, "Beer"], [:jane, "Water"]]
          (A.likes(B).and(B.matches {|a,b|a})).to_a.should == []
        end


      end
