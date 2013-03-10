
      describe "and" do
        it "works 1" do
          :john.happy.if :fail.and :true
          :john.should_not be_happy
        end

        it "works 2" do
          :john.happy.if :true.and :fail
          :john.should_not be_happy
        end

        it "works 3" do
          :john.happy.if :fail.and :fail
          :john.should_not be_happy
        end

        it "works 4" do
          :john.happy.if :true.and :true
          :john.should be_happy
        end
      end
      describe "and" do
        specify do
          (X.is(1).and X.var).to_a.should == []
          (X.var.and X.is(1)).to_a.should == [1]
          (:fail.and :call[3]).to_a.should == []
          lambda { (:nofoo[X].and X.call).to_a }.
            should raise_error ExistenceError
          (X.is(:true).and X.call).should == [:true]
        end
      end


