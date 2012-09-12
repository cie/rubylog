
      describe "in" do
        before do
          :john.likes! :beer
          :jane.likes! :milk
        end

        it "works for variables" do
          (A.likes(B).and(B.in [])).to_a.should == []
          (A.likes(B).and(B.in [:milk])).to_a.should == [[:jane, :milk]]
          (A.likes(B).and(B.in [:beer])).to_a.should == [[:john, :beer]]
          (A.likes(B).and(B.in [:milk, :beer])).to_a.should == [[:john, :beer], [:jane, :milk]]
        end

        it "works with blocks" do
          (A.likes(B).and(B.in {[]})).to_a.should == []
          (A.likes(B).and(B.in {|a|[a,:milk]})).to_a.should == [[:jane, :milk]]
          (A.likes(B).and(B.in {|a,b|[:beer]})).to_a.should == [[:john, :beer]]
          (A.likes(B).and(B.in {|a,b|[b]})).to_a.should == [[:john, :beer], [:jane, :milk]]
        end

        it "works as iterator" do
          (A.in{[1,3,4]}).to_a.should == [1,3,4]
          (A.in [1,3,4]).to_a.should == [1,3,4]
        end

        it "works as search" do
          (1.in{[1,3,4]}).to_a.should == [nil]
          (2.in{[1,3,4]}).to_a.should == []
          (1.in [1,3,4]).to_a.should == [nil]
          (2.in [1,3,4]).to_a.should == []
        end

        it "works with clauses" do
          (A.likes(B).and B.in{:john.likes(X)}).to_a.should == [[:john, :beer]]
        end

      end
