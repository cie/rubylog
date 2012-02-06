require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec::Matchers.define :stand do 
  match do |actual|
    actual.true?
  end
end


class << Rubylog.theory
  Symbol.rubylog_functor \
    :likes, :is_happy, :in, :has, :we_have,
    :brother, :father, :uncle, :neq, :happy, :%
  Integer.rubylog_functor :divides, :queens
  Rubylog::Clause.rubylog_functor :-

  describe Rubylog do
    before do
      Rubylog.theory.clear
    end



    describe "facts" do
      it "can be asserted with assert" do
        Rubylog.theory.assert(:john.is_happy)
        Rubylog.theory.database[:is_happy][1].should include(Rubylog::Clause.new :-, :john.is_happy, :true)
        Rubylog.theory.assert(:john.likes :beer)
        Rubylog.theory.database[:likes][2].should include(Rubylog::Clause.new :-, :john.likes(:beer), :true)
        Rubylog.theory.assert(:john.likes :drinking.in :bar)
        Rubylog.theory.database[:likes][2].should include(:john.likes(:drinking.in :bar) - :true)
      end

      it "can be asserted with a bang, and it returns the zeroth arg" do
        :john.is_happy!.should == :john
        Rubylog.theory.database[:is_happy][1].should include(:john.is_happy.-:true)
        :john.likes!(:beer).should == :john
        Rubylog.theory.database[:likes][2].should include(:john.likes(:beer).-:true)
        :john.likes!(:drinking.in :bar).should == :john
        Rubylog.theory.database[:likes][2].should include(:john.likes(:drinking.in :bar).-:true)
      end


    end

    describe "compilation" do

      it "makes eql variables be equal" do
        a = A; b = A
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
        c = c.rubylog_compile_variables
        c[0].should be_equal c[1]
      end

      it "makes non-eql variables be non-equal" do
        a = A; b = B
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
        c = c.rubylog_compile_variables
        c[0].should_not be_equal c[1]
      end

      it "makes dont-care variables be non-equal" do
        a = ANY; b = ANY
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c[0].should_not be_equal c[1]
        c = c.rubylog_compile_variables
        c[0].should_not be_equal c[1]
      end

      it "creates new variables" do
        a = A; b = B
        c = (a.likes b)
        c[0].should be_equal a; c[1].should be_equal b
        c = c.rubylog_compile_variables
        c[0].should_not be_equal a
        c[1].should_not be_equal a
        c[0].should_not be_equal b
        c[1].should_not be_equal b
      end

      it "makes variables available" do
        a = A; a1 = A; a2 = A; b = B; b1 = B; c = C;
        (a.likes b).rubylog_compile_variables.rubylog_variables.should == [a, b]
        (a.likes a1).rubylog_compile_variables.rubylog_variables.should == [a]
        (a.likes a1.in b).rubylog_compile_variables.rubylog_variables.should == [a, b]
        (a.likes a1,b,b1,a2,c).rubylog_compile_variables.rubylog_variables.should == [a, b, c]
      end

      it "does not make dont-care variables available" do
        a = ANY; a1 = ANYTHING; a2 = ANYTHING; b = B; b1 = B; c = C;
        (a.likes b).rubylog_compile_variables.rubylog_variables.should == [b]
        (a.likes a1).rubylog_compile_variables.rubylog_variables.should == []
        (a.likes a1.in b).rubylog_compile_variables.
          rubylog_variables.should == [b]
        (a.likes a1,b,b1,a2,c).rubylog_compile_variables.
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
        (A.likes A).rubylog_compile_variables.rubylog_unify(:john.likes :jane) { result = true }
        result.should == false
        (A.likes A).rubylog_compile_variables.rubylog_unify(:john.likes :john) { result = true }
        result.should == true
      end
      it "works on clauses with repeated variables #1" do
        result = false
        (:john.likes :jane).rubylog_unify(A.likes(A).rubylog_compile_variables) { result = true }
        result.should == false
        (:john.likes :john).rubylog_unify(A.likes(A).rubylog_compile_variables) { result = true }
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

    describe "custom classes" do
      before do
        class User
          rubylog_functor :girl, :boy
          include Rubylog::DSL::Constants

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

        Rubylog.theory[:girl][1].discontinuous!
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

      it "false" do
        :john.happy.if :false
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
          (A.is {4+4}).to_a.should == [8]
          (A.is(4).and A.is{2*2}).to_a.should == [4]
          (A.is(4).and A.is{2*3}).to_a.should == []
        end

        it "works as calculation with vars" do
          (A.is(4).and B.is{|a|a*4}).to_a.should == [[4,16]]
          (A.is(4).and A.is{|a|a*1}).to_a.should == [4]
          (A.is(4).and A.is{|a|a*2}).to_a.should == []
        end

      end

      describe "matches" do
        before do
          :john.likes! "Beer"
          :jane.likes! "Water"
        end

        it "works for variables" do
          (A.likes(B).and(B.matches /e/)).to_a.should == [[:john, "Beer"], [:jane, "Water"]]
          (A.likes(B).and(B.matches /ee/)).to_a.should == [[:john, "Beer"]]
          (A.likes(B).and(B.matches /w/i)).to_a.should == [[:jane, "Water"]]
        end

        it "works as calculation" do
          (A.likes(B).and(B.matches {|a,b|/e/})).to_a.should == [[:john, "Beer"], [:jane, "Water"]]
          (A.likes(B).and(B.matches {|a,b|/ee/})).to_a.should == [[:john, "Beer"]]
          (A.likes(B).and(B.matches {|a,b|/w/i})).to_a.should == [[:jane, "Water"]]
          (A.likes(B).and(B.matches {|a,b|b})).to_a.should == [[:john, "Beer"], [:jane, "Water"]]
          (A.likes(B).and(B.matches {|a,b|a})).to_a.should == []
        end


      end

      describe "in" do
        before do
          :john.likes! :beer
          :jane.likes! :milk
        end

        it "works for variables" do
          (A.likes(B).and(B.in [])).to_a.should == []
          (A.likes(B).and(B.in [:milk])).to_a.should == [[:jane, :milk]]
          (A.likes(B).and(B.in [:beer])).to_a.should == [[:john, :beer]]
          (A.likes(B).and(B.in [:milk, :beer])).to_a.should == [[:john, :beer], [:jane, :milk]]
        end

        it "works with blocks" do
          (A.likes(B).and(B.in {[]})).to_a.should == []
          (A.likes(B).and(B.in {|a|[a,:milk]})).to_a.should == [[:jane, :milk]]
          (A.likes(B).and(B.in {|a,b|[:beer]})).to_a.should == [[:john, :beer]]
          (A.likes(B).and(B.in {|a,b|[b]})).to_a.should == [[:john, :beer], [:jane, :milk]]
        end

        it "works as iterator" do
          (A.in{[1,3,4]}).to_a.should == [1,3,4]
          (A.in [1,3,4]).to_a.should == [1,3,4]
        end

        it "works as search" do
          (1.in{[1,3,4]}).to_a.should == [nil]
          (2.in{[1,3,4]}).to_a.should == []
          (1.in [1,3,4]).to_a.should == [nil]
          (2.in [1,3,4]).to_a.should == []
        end

        it "works with clauses" do
          (A.likes(B).and B.in{:john.likes(X)}).to_a.should == [[:john, :beer]]
        end

      end

      describe "all,any,one,none" do
        before do
          :john.likes! :water
          :john.likes! :beer

          :jane.likes! :water
          :jane.likes! :milk
          :jane.likes! :beer

          :jeff.likes! :water
          :jeff.likes! :absinth

          :todd.likes! :milk

          @predicates = [:all, :any, :one, :none]
          @names = :john, :jane, :jeff, :todd
          @good =
            [
              [[1,1,0,0], [0,1,0,0], [0,0,1,0], [0,1,0,1]], # all
              [[1,1,1,0], [1,1,1,1], [1,1,1,0], [0,1,0,1]], # any
              [[0,0,1,0], [0,0,1,1], [1,1,0,0], [0,1,0,1]], # one
              [[0,0,0,1], [0,0,0,0], [0,0,0,1], [1,0,1,0]]  # none
            ]
        end

        it "work" do
          @predicates.map{|p| @names.map{|n| @names.map{|m| 
            (n.likes(K).send p, m.likes(K)).true? ? 1 : 0
          }}}.should == @good
        end

        it "mimic well enumerators' predicates" do
          @predicates.map{|p| @names.map{|n| @names.map{|m|
            n.likes(K).to_a.send(:"#{p}?"){|x| m.likes?(x) } ? 1 : 0
          }}}.should == @good
        end


        
        it "all works" do
          (:john.likes(X).all(:john.likes(X))).should stand
          (:john.likes(X).all(:jane.likes(X))).should stand
          (:john.likes(X).all(:jeff.likes(X))).should_not stand
          (:john.likes(X).all(:todd.likes(X))).should_not stand

          (:jane.likes(X).all(:john.likes(X))).should_not stand
          (:jane.likes(X).all(:jane.likes(X))).should stand
          (:jane.likes(X).all(:jeff.likes(X))).should_not stand
          (:jane.likes(X).all(:todd.likes(X))).should_not stand

          (:jeff.likes(X).all(:john.likes(X))).should_not stand
          (:jeff.likes(X).all(:jane.likes(X))).should_not stand
          (:jeff.likes(X).all(:jeff.likes(X))).should stand
          (:jeff.likes(X).all(:todd.likes(X))).should_not stand

          (:todd.likes(X).all(:john.likes(X))).should_not stand
          (:todd.likes(X).all(:jane.likes(X))).should stand
          (:todd.likes(X).all(:jeff.likes(X))).should_not stand
          (:todd.likes(X).all(:todd.likes(X))).should stand
        end

        it "can be called with global functor syntax" do
          extend Rubylog::DSL::GlobalFunctors
          all(:john.likes(X), :jane.likes(X)).should stand
          all(:jane.likes(X), :john.likes(X)).should_not stand
          any(:jane.likes(X), :todd.likes(X)).should stand
          any(:john.likes(X), :todd.likes(X)).should_not stand
        end

        it "can be called unarily" do
          extend Rubylog::DSL::GlobalFunctors
          one(:john.likes(X)).should_not stand
          one(:jane.likes(X)).should_not stand
          one(:jeff.likes(X)).should_not stand
          one(:todd.likes(X)).should stand
          one(:jim.likes(X)).should_not stand

          any(:john.likes(X)).should stand
          any(:jane.likes(X)).should stand
          any(:jeff.likes(X)).should stand
          any(:todd.likes(X)).should stand
          any(:jim.likes(X)).should_not stand

          all(:john.likes(X)).should stand
          all(:jane.likes(X)).should stand
          all(:jeff.likes(X)).should stand
          all(:todd.likes(X)).should stand
          all(:jim.likes(X)).should stand

          none(:john.likes(X)).should_not stand
          none(:jane.likes(X)).should_not stand
          none(:jeff.likes(X)).should_not stand
          none(:todd.likes(X)).should_not stand
          none(:jim.likes(X)).should stand
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







