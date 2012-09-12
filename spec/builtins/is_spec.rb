
      describe "is" do
        before do
          :john.likes! :beer
          :jane.likes! :milk
        end

        it "works for variables" do
          (A.likes(B).and(B.is :milk)).to_a.should == [[:jane, :milk]]
          (A.likes(B).and(:milk.is B)).to_a.should == [[:jane, :milk]]
        end

        it "works as calculation" do
          (A.is {|| 4+4}).to_a.should == [8]
          (A.is {4+4}).to_a.should == [8]
          (A.is(4).and A.is{2*2}).to_a.should == [4]
          (A.is(4).and A.is{2*3}).to_a.should == []
        end

        it "works as calculation with vars" do
          (A.is(4).and B.is{|a|a*4}).to_a.should == [[4,16]]
          (A.is(4).and A.is{|a|a*1}).to_a.should == [4]
          (A.is(4).and A.is{|a|a*2}).to_a.should == []
        end

      end
