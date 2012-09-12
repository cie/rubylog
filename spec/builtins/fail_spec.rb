
      it "fail" do
        :john.happy.if :fail
        :john.should_not be_happy
      end
