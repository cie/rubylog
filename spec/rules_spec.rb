
    describe "rules" do
      describe "with prolog body" do
        it "cannot be asserted in a builtin's desc" do
          lambda {
            :john.likes(:beer).and! :jane.likes(:milk)
          }.should raise_error(Rubylog::BuiltinPredicateError)
        end

        it "can be asserted with if" do
          Rubylog.theory.predicate [:we_have, 2]
          :john.is_happy.if :-@.we_have(:beer)
          :john.is_happy?.should be_false
          :-@.we_have!(:beer)
          :john.is_happy?.should be_true
        end

        it "can be asserted with unless" do
          Rubylog.theory.predicate [:we_have, 2]
          :john.is_happy.unless :-@.we_have(:problem)
          :john.is_happy?.should be_true
          :-@.we_have!(:problem)
          :john.is_happy?.should be_false
        end

        it "can do simple general implications" do
          Rubylog.theory.predicate [:is_happy,1], [:has,2]
          Rubylog.theory.discontinuous [:likes,2]
          X.is_happy.if X.likes(Y).and X.has(Y)
          :john.likes! :milk
          :john.is_happy?.should be_false
          :john.has! :beer
          :john.is_happy?.should be_false
          :john.likes! :beer
          :john.is_happy?.should be_true
        end

        it "can yield implied solutions" do
          X.brother(Y).if X.father(Z).and Y.father(Z).and X.neq(Y)
          X.uncle(Y).if X.father(Z).and Z.brother(Y)
          X.neq(Y).if proc {|x,y|x != y}

          :john.father! :dad
          :jack.father! :dad
          :dad.father! :grandpa
          :jim.father! :grandpa

          (:john.brother X).to_a.should == [:jack]
          (:john.father X).to_a.should == [:dad]
          (X.father :dad).to_a.should == [:john, :jack]
          (ANY.father X).to_a.should == [:dad, :dad, :grandpa, :grandpa]
          (:john.uncle X).to_a.should == [:jim]
        end
      end

      describe "with ruby body" do
        it "can be asserted (true)" do
          :john.is_happy.if proc{ true }
          :john.is_happy?.should be_true
        end
        it "can be asserted (false)" do
          :john.is_happy.if proc{ false }
          :john.is_happy?.should be_false
        end

        it "can be asserted implicitly (true)" do
          :john.is_happy.if { true }
          :john.is_happy?.should be_true
        end

        it "can be asserted implicitly (false)" do
          :john.is_happy.if { false }
          :john.is_happy?.should be_false
        end

        it "run the body during every query" do
          count = 0
          :john.is_happy.if proc{ count += 1 }
          count.should == 0
          :john.is_happy?
          count.should == 1
          :john.is_happy?
          count.should == 2
        end

        it "can take arguments" do
          (A.divides B).if proc{|a,b| b % a == 0}
          (4.divides? 16).should be_true
          (4.divides? 17).should be_false
          (4.divides? 18).should be_false
          (3.divides? 3).should be_true
          (3.divides? 4).should be_false
          (3.divides? 5).should be_false
          (3.divides? 6).should be_true
        end
      end
    end