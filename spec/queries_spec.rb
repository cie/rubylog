
    describe "queries" do
      it "can be run with true?" do
        lambda {Rubylog.theory.true?(:john.likes :beer)}.should raise_error(Rubylog::ExistenceError)
        :john.likes! :beer
        Rubylog.theory.true?(:john.likes :beer).should be_true
        Rubylog.theory.true?(:john.likes :milk).should be_false
      end

      it "can be run with question mark" do
        lambda {Rubylog.theory.true?(:john.likes :beer)}.should raise_error(Rubylog::ExistenceError)
        :john.likes! :beer
        :john.likes?(:beer).should be_true
      end

      it "can be run with true?" do
        lambda {Rubylog.theory.true?(:john.likes :beer)}.should raise_error(Rubylog::ExistenceError)
        :john.likes! :beer
        (:john.likes(:beer)).true?.should be_true
      end
      
      it "work with variables" do
        lambda {Rubylog.theory.true?(:john.likes X)}.should raise_error(Rubylog::ExistenceError)
        :john.likes! :water
        :john.likes?(X).should be_true
      end

      it "yield all solutions" do
        :john.likes! :beer
        :john.likes! :milk

        k=[]
        (:john.likes X).each{|x|k << x}
        k.should == [:beer, :milk]
      end

      it "yield all solutions with solve" do
        :john.likes! :beer
        :john.likes! :milk

        k=[]
        (:john.likes X).solve{|x|k << x}
        k.should == [:beer, :milk]
      end

      it "yield all solutions with solve and multiple vars and multiple block parameters" do
        :john.likes! :beer
        :jane.likes! :milk
        :jane.likes! :water

        k=[]
        (X.likes Y).solve{|a,b|k << [a,b]}
        k.should == [[:john, :beer], [:jane, :milk], [:jane, :water]]
      end

      it "ignore don't-care variables" do
        :john.likes! :beer

        k=[]
        ANYONE.likes(X).each{|x|k << x}
        k.should == [:beer]

        k=[]
        X.likes(ANYTHING).each{|x|k << x}
        k.should == [:john]
      end

      it "makes sure all variables are instantiated" do
        res = []
        A.likes(B).if {|a,b| res << a << b }
        A.likes? :beer
        res.should == [nil,:beer]
      end

      it "substitutes deeper variables" do
        res = []
        A.likes(B).if {|a,b| res << a << b }
        (A.is(:john).and B.is(:swimming.in C).and 
         C.is(:sea).and A.likes B).to_a.should == [[:john,:swimming.in(:sea),:sea]]
        res.should == [:john, :swimming.in(:sea)]
      end


      describe "support Enumerable" do
        before do
          :john.likes! :beer
          :john.likes! :milk
        end

        it "#all?, #any? and #none?" do
          (:john.likes A).all?{|a| Symbol===a}.should be_true
          (:john.likes A).all?{|a| a == :beer}.should be_false
          (:john.likes A).all?{|a| a == :beer or a == :milk}.should be_true
          (:john.likes A).any?{|a| a == :beer}.should be_true
          (:john.likes A).any?{|a| a == :milk}.should be_true
          (:john.likes A).any?{|a| a == :water}.should be_false
          (:john.likes A).none?{|a| a == :water}.should be_true
          (:john.likes A).none?{|a| a == :beer}.should be_false
        end

        it "#to_a" do
          (:john.likes A).to_a.should == [:beer, :milk]
          (X.likes A).to_a.should == [[:john, :beer], [:john, :milk]]
          (ANYONE.likes A).to_a.should == [:beer, :milk]
        end

        it "#first" do
          (:john.likes A).first.should == :beer
        end

        it "#map" do
          (:john.likes A).map{|a|a.to_s}.should == ['beer', 'milk']
        end

        it "#include? and #member?" do
          (:john.likes B).member?(:beer).should be_true
          (:john.likes B).include?(:beer).should be_true
          (:john.likes B).member?(:milk).should be_true
          (:john.likes B).include?(:milk).should be_true
          (:john.likes B).member?(:water).should be_false
          (:john.likes B).include?(:water).should be_false
        end
        
      end

      it "can yield solutions with vars substituted" do
        :john.likes! :beer
        :john.likes! :milk
        :jane.likes! :milk

        (A.likes B).solutions.should == [
          :john.likes(:beer),
          :john.likes(:milk),
          :jane.likes(:milk)
        ]
        (A.likes(B).and A.is :john).solutions.should == [
          :john.likes(:beer).and(:john.is :john),
          :john.likes(:milk).and(:john.is :john)
        ]
        (:john.likes(B)).solutions.should == [
          :john.likes(:beer),
          :john.likes(:milk)
        ]
        (A.likes(:milk)).solutions.should == [
          :john.likes(:milk),
          :jane.likes(:milk)
        ]
      end

    end
