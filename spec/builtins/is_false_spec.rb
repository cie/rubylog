
      describe "is_false" do
        it "works 5" do
          :john.happy.if :true.is_false
          :john.should_not be_happy
        end

        it "works 5" do
          :john.happy.if :fail.is_false
          :john.should be_happy
        end
      end
