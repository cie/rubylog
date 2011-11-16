require 'rubylog'


class << Rubylog::Theory.new
  Symbol.rubylog_predicate \
    :likes, :is_happy, :/, :in, :has, :we_have,
    :brother, :father, :uncle, :neq, :happy
  Integer.rubylog_predicate :divides, :queens
  Rubylog::Clause.rubylog_predicate :-

  describe Rubylog do
    before do
      @theory = Rubylog::Theory.new!
    end

    describe "variables" do
      it "are undefined constants" do 
        [A, SomethingLong].each{|x|x.should be_kind_of Rubylog::Variable}
      end
    end

    describe "don't care variables" do
      it "are variables that start with ANY..." do 
        [ANY, ANYTHING, ANYTIME].each{|x|x.should be_kind_of Rubylog::DontCareVariable}
      end
    end


    describe "clauses" do
      it "can be created" do
        (:john.is_happy).should be_kind_of Rubylog::Term
        (:john.likes :beer).should be_kind_of Rubylog::Term
        (A.likes :beer).should be_kind_of Rubylog::Term
        (:john.likes Drink).should be_kind_of Rubylog::Term
        (:john.likes :drinking.in :bar).should be_kind_of Rubylog::Term
      end
      it "forbids non-declared names" do
        lambda { :john.something_else }.should raise_error(NoMethodError)
      end
      it "also work with operators" do
        (:is_happy/1).should be_kind_of Rubylog::Term
        (A/B).should be_kind_of Rubylog::Term
      end
      it "can be asked for their functor" do
        (:john.is_happy).functor.should == :is_happy
        (:is_happy/1).functor.should == :/
        (A/1).functor.should == :/
        (:john.likes :drinking.in :bar).functor.should == :likes
      end
      it "can be indexed" do
        (:john.is_happy)[0].should == :john
        (:john.likes :beer)[0].should == :john
        (:john.likes :beer)[1].should == :beer
        (:john.likes(:cold, :beer))[2].should == :beer
        (:john.likes(:cold, :beer))[1..2].should == [:cold,:beer]
        (:john.likes :drinking.in :bar)[1].should == (:drinking.in :bar)
      end
      it "can be asked for their args" do
        (:john.is_happy).args.should == [:john]
        (:john.likes :beer).args.should == [:john, :beer]
        (:john.likes(:cold, :beer)).args.should == [:john, :cold, :beer]
        (:john.likes :drinking.in :bar).args.should == [:john, :drinking.in(:bar)]
      end
      it "support ==" do
        (:john.is_happy).should == (:john.is_happy)
        (:john.is_happy).should_not be_equal(:john.is_happy)
        (:john.is_happy).should_not == nil
        (:john.is_happy).should_not == 9
        (:john.is_happy).should_not == :john
        (:john.is_happy).should_not == Rubylog
        (:john.likes :drinking.in :bar).should == (:john.likes :drinking.in :bar)
      end
      it "support eql?" do
        (:john.is_happy).should be_eql(:john.is_happy)
        (:john.is_happy).should_not be_eql nil
        (:john.is_happy).should_not be_eql 9
        (:john.is_happy).should_not be_eql :john
        (:john.is_happy).should_not be_eql Rubylog
        (:john.likes :drinking.in :bar).should be_eql(:john.likes :drinking.in :bar)
      end
      it "support hash" do
        (:john.is_happy).hash.should == (:john.is_happy).hash
        (:john.likes :drinking.in :bar).hash.should == 
          (:john.likes :drinking.in :bar).hash
      end
      it "support inspect" do
        (:john.is_happy).inspect.should == ":john.is_happy"
        (:john.likes :beer).inspect.should == ":john.likes(:beer)"
        (:john.likes :drinking,:beer).inspect.should == ":john.likes(:drinking, :beer)"
        (:john.likes :drinking.in :bar).inspect.should == ":john.likes(:drinking.in(:bar))"
      end
      it "can tell their arity" do
        (:john.is_happy).arity.should == 1
        (:john.likes :beer).arity.should == 2
        (:john.likes :drinking,:beer).arity.should == 3
        (:john.likes :drinking.in :bar).arity.should == 2
      end
      it "can tell their descriptor" do
        (:john.is_happy).desc.should == :is_happy/1
        (:john.likes :beer).desc.should == :likes/2
        (:john.likes :drinking,:beer).desc.should == :likes/3
        (:john.likes :drinking.in :bar).desc.should == :likes/2
      end
    end

    describe "facts" do
      it "can be asserted with assert" do
        @theory.assert(:john.is_happy)
        @theory.database[:is_happy/1].should include(Rubylog::Clause.new :-, :john.is_happy, :true)
        @theory.assert(:john.likes :beer)
        @theory.database[:likes/2].should include(Rubylog::Clause.new :-, :john.likes(:beer), :true)
        @theory.assert(:john.likes :drinking.in :bar)
        @theory.database[:likes/2].should include(:john.likes(:drinking.in :bar) - :true)
      end

      it "can be asserted with a bang" do
        :john.is_happy!
        @theory.database[:is_happy/1].should include(:john.is_happy.-:true)
        :john.likes! :beer
        @theory.database[:likes/2].should include(:john.likes(:beer).-:true)
        :john.likes! :drinking.in :bar
        @theory.database[:likes/2].should include(:john.likes(:drinking.in :bar).-:true)
      end

    end

    describe "compilation" do

      it "makes eql variables be equal" do
        a = A; b = A
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
        c.compile_variables!
        c[0].should be_equal a; c[1].should be_equal a
        c[0].should be_equal c[1]
      end

      it "makes non-eql variables be non-equal" do
        a = A; b = B
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
        c.compile_variables!
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
      end

      it "makes dont-care variables be non-equal" do
        a = ANY; b = ANY
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
        c.compile_variables!
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
      end

      it "returns self" do
        a = A; b = B
        c = (a.likes b)
        c.compile_variables!.should be_equal c
      end

      it "makes variables available" do
        a = A; a1 = A; a2 = A; b = B; b1 = B; c = C;
        (a.likes b).compile_variables!.rubylog_variables.should == [a, b]
        (a.likes a1).compile_variables!.rubylog_variables.should == [a]
        (a.likes a1.in b).compile_variables!.rubylog_variables.should == [a, b]
        (a.likes a1,b,b1,a2,c).compile_variables!.rubylog_variables.should == [a, b, c]
      end

      it "does not make dont-care variables available" do
        a = ANY; a1 = ANYTHING; a2 = ANYTHING; b = B; b1 = B; c = C;
        (a.likes b).compile_variables!.rubylog_variables.should == [b]
        (a.likes a1).compile_variables!.rubylog_variables.should == []
        (a.likes a1.in b).compile_variables!.
          rubylog_variables.should == [b]
        (a.likes a1,b,b1,a2,c).compile_variables!.
          rubylog_variables.should == [b, c]
      end


    end

    describe "unification" do
      it "works for variables" do
        result = false
        A.rubylog_unify(12) { result = true }
        result.should == true
      end
      it "works for used classes" do
        result = false
        :john.rubylog_unify(A) { result = true }
        result.should == true
      end
      it "works for constants" do
        result = false
        :john.rubylog_unify(:john) { result = true }
        result.should == true
      end
      it "fails for different constants" do
        result = false
        :john.rubylog_unify(:mary) { result = true }
        result.should == false
      end
      it "works on clauses" do
        result = false
        (:john.likes :beer).rubylog_unify(A.likes B) { result = true }
        result.should == true
      end
      it "works on clauses with equal values" do
        result = false
        (:john.likes :beer).rubylog_unify(:john.likes :beer) { result = true }
        result.should == true
      end
      it "works on clauses with different values" do
        result = false
        (:john.likes :beer).rubylog_unify(:john.likes :milk) { result = true }
        result.should == false
      end
      it "works on clauses with variables and equal values" do
        result = false
        (:john.likes :beer).rubylog_unify(X.likes :beer) { result = true }
        result.should == true
      end
      it "works on clauses with variables and equal values #2" do
        result = false
        (:john.likes :beer).rubylog_unify(:john.likes DRINK) { result = true }
        result.should == true
      end
      it "works on clauses with variables and different values" do
        result = false
        (:john.likes :beer).rubylog_unify(X.likes :milk) { result = true }
        result.should == false
      end
      it "works on clauses with variables and different values #2" do
        result = false
        (:john.likes :beer).rubylog_unify(:jane.likes D) { result = true }
        result.should == false
      end

      it "works on clauses with repeated variables #1" do
        result = false
        (A.likes A).compile_variables!.rubylog_unify(:john.likes :jane) { result = true }
        result.should == false
        (A.likes A).compile_variables!.rubylog_unify(:john.likes :john) { result = true }
        result.should == true
      end
      it "works on clauses with repeated variables #1" do
        result = false
        (:john.likes :jane).rubylog_unify(A.likes(A).compile_variables!) { result = true }
        result.should == false
        (:john.likes :john).rubylog_unify(A.likes(A).compile_variables!) { result = true }
        result.should == true
      end

      it "works for second-order variables" do
        result = false
        (:john.likes :beer).rubylog_unify(A) { result = true }
        result.should == true
      end

    end

    describe "queries" do
      it "can be run with true?" do
        @theory.true?(:john.likes :beer).should be_false
        :john.likes! :beer
        @theory.true?(:john.likes :beer).should be_true
      end

      it "can be run with question mark" do
        :john.likes?(:beer).should be_false
        :john.likes! :beer
        :john.likes?(:beer).should be_true
      end

      it "can be run with true?" do
        (:john.likes(:beer)).true?.should be_false
        :john.likes! :beer
        (:john.likes(:beer)).true?.should be_true
      end
      
      it "work with variables" do
        :john.likes?(X).should be_false
        :john.likes! :water
        :john.likes?(X).should be_true
      end

      it "yield all solutions" do
        :john.likes! :beer

        k=[]
        (:john.likes X).each{|x|k << x}
        k.should == [:beer]
      end

      it "yield all solutions with solve" do
        :john.likes! :beer

        k=[]
        (:john.likes X).solve{|x|k << x}
        k.should == [:beer]
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

    end

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

        it "makes sure all variables are instantiated" do
          res = []
          A.likes(B).if {|a,b| res << a << b }
          A.likes? :beer
          res.should == [nil,:beer]
        end

      end
    end

    describe "rules" do
      describe "with prolog body" do
        it "can be asserted with if" do
          :john.is_happy.if :-@.we_have(:beer)
          :john.is_happy?.should be_false
          :-@.we_have!(:beer)
          :john.is_happy?.should be_true
        end

        it "can be asserted with unless" do
          :john.is_happy.unless :-@.we_have(:problem)
          :john.is_happy?.should be_true
          :-@.we_have!(:problem)
          :john.is_happy?.should be_false
        end

        it "can do simple general implications" do
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

    describe "custom classes" do
      before do
        class User
          rubylog_predicate :girl, :boy

          attr_reader :name
          def initialize name
            @name = name
          end
          
          U.girl.if {|u| u.name =~ /[aeiouh]$/ }
          U.boy.unless U.girl
        end
      end

      it "can have ruby predicates" do
        john = User.new "John"
        john.girl?.should be_false
        john.boy?.should be_true
        jane = User.new "Jane"
        jane.girl?.should be_true
        jane.boy?.should be_false
      end
      
      it "can be used in assertions" do
        pete = User.new "Pete"
        pete.boy?.should be_false
        pete.boy!
        pete.boy?.should be_true

        janet = User.new "Janet"
        janet.girl?.should be_false
        janet.girl!
        janet.girl?.should be_true
      end




    end


    describe "builtin" do
      it "true" do
        :john.happy.if :true
        :john.should be_happy
      end

      it "fail" do
        :john.happy.if :fail
        :john.should_not be_happy
      end

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

      describe "or" do
        it "works 1" do
          :john.happy.if :fail.or :true
          :john.should be_happy
        end

        it "works 2" do
          :john.happy.if :true.or :fail
          :john.should be_happy
        end

        it "works 3" do
          :john.happy.if :fail.or :fail
          :john.should_not be_happy
        end

        it "works 4" do
          :john.happy.if :true.or :true
          :john.should be_happy
        end
      end

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

      describe "is" do
        before do
          :john.likes! :beer
          :jane.likes! :milk
        end

        it "works for variables" do
          (A.likes(B).and(B.is :milk)).to_a.should == [[:jane, :milk]]
          (A.likes(B).and(:milk.is B)).to_a.should == [[:jane, :milk]]
        end

        it "works as calculation" do
          (A.is {|| 4+4}).to_a.should == [8]
          (A.is(4).and A.is{2*2}).to_a.should == [4]
          (A.is(4).and A.is{2*3}).to_a.should == []
        end

        it "works as calculation with vars" do
          (A.is(4).and B.is{|a|a*4}).to_a.should == [[4,16]]
          (A.is(4).and A.is{|a|a*1}).to_a.should == [4]
          (A.is(4).and A.is{|a|a*2}).to_a.should == []
        end

      end

    end

    describe "Array" do
      it "can be unified" do
        result = false
        [A,B].rubylog_unify(12) { result = true }
        result.should == false

        result = false
        [A,B].rubylog_unify([12,13]) { result = true }
        result.should == true

        result = false
        [14,B].rubylog_unify([12,13]) { result = true }
        result.should == false
      end
    end




  end


end








