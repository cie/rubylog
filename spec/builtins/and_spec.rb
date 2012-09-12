
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
