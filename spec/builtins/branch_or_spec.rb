

      describe "branch or" do
        it "works 1" do
          :john.happy.if :fail
          :john.happy.if :true
          :john.should be_happy
        end

        it "works 2" do
          :john.happy.if :true
          :john.happy.if :fail
          :john.should be_happy
        end

        it "works 3" do
          :john.happy.if :fail
          :john.happy.if :fail
          :john.should_not be_happy
        end

        it "works 4" do
          :john.happy.if :true
          :john.happy.if :true
          :john.should be_happy
        end
      end
