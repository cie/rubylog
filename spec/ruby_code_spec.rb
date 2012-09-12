
    describe "using ruby code in clauses" do
      it "works" do
        (:true.and? {false}).should be_false
        (:true.and? {true}).should be_true
        (:false.and? {false}).should be_false
        (:false.and? {true}).should be_false
        (:true.or? {false}).should be_true
        (:true.or? {true}).should be_true
        (:false.or? {false}).should be_false
        (:false.or? {true}).should be_true

        (:fail.or? {false}).should be_false
        (:fail.or? {true}).should be_true
      end
      it "runs the query once at every evaluation" do
        count = 0
        :john.is_happy.if :true.and { count += 1 }
        count.should == 0
        :john.is_happy?
        count.should == 1
        :john.is_happy?
        count.should == 2
        (:false.or? {count+=1}).should be_true
        count.should == 3
      end

      describe "bindings" do
        it "works for rule bodies" do
          result = nil; 
          (A.likes(B).if {|*args| result = args})
          (:john.likes(:beer)).solve{}
          result.should == [:john,:beer]
        end

        it "works for rules" do
          result = nil
          (A.likes(B).if B.is(4).and A.is(2).and C.is(5).and {|*args| result = args})
          (A.likes(B)).solve{}
          result.should == [2,4,5]
        end

        it "works for inline terms" do
          result = nil
          (A.is(1).and B.is(2).and {|*args| result = args}).solve{}
          result.should == [1,2]
        end



      end
    end
