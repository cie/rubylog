
      it "false" do
        :john.happy.if :false
        :john.should_not be_happy
      end
