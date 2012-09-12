
      describe "cut" do
        it "works with branch or" do
          :john.happy.if :true.and :cut.and :fail
          :john.happy.if :true
          :john.should_not be_happy
        end
        it "works with branch or (control)" do
          :john.happy.if :true.and :fail
          :john.happy.if :true
          :john.should be_happy
        end

        it "works with or" do
          :john.happy.if((:true.and :cut.and :fail).or :true)
          :john.should_not be_happy
        end

        it "works with or (control)" do
          :john.happy.if((:true.and :fail).or :true)
          :john.should be_happy
        end

        it "returns true with branch or" do
          :john.happy.if :true.and :cut.and :true
          :john.happy.if :true
          :john.should be_happy
        end
        it "returns true with branch or (control)" do
          :john.happy.if :true.and :true
          :john.happy.if :true
          :john.should be_happy
        end

        it "returns true with or" do
          :john.happy.if((:true.and :cut.and :true).or :true)
          :john.should be_happy
        end

        it "returns true with or (control)" do
          :john.happy.if((:true.and :true).or :true)
          :john.should be_happy
        end
      end
