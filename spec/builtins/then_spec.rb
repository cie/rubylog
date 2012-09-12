
      describe "then" do
        it "works 1" do
          :john.happy.if :fail.then :true
          :john.should_not be_happy
        end

        it "works 2" do
          :john.happy.if :true.then :fail
          :john.should_not be_happy
        end

        it "works 3" do
          :john.happy.if :fail.then :fail
          :john.should_not be_happy
        end

        it "works 4" do
          :john.happy.if :true.then :true
          :john.should be_happy
        end

        it "works 5" do
          :john.happy.if :true.then :true
          :john.should be_happy
        end
      end
