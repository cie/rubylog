require 'rubylog'


Rubylog.use :variables

class Symbol
  include Rubylog::Term
  rubylog_predicate :likes, :is_happy, :/, :in, :has, :we_have, :-
end

class Integer
  include Rubylog::Term
  rubylog_predicate :divides
end

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
    it "forbids non-predicate names" do
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

  #describe "unification" do
    #pending; next
    #it "works on terms" do
      #((:john.likes :beer) === (A.likes B)).to_a.should == [(:john.likes :beer)]
    #end
    #it "works for variables" do
      #(A === 12).to_a.should == [12]
    #end
    #it "works for used classes" do
      #(:john === X).to_a.should == [:john]
    #end
    #it "works for constants" do
      #(:jane === :jane).to_a.should == [:jane]
    #end
    #it "fails for different constants" do
      #(:john === :jane).to_a.should be_false
    #end
  #end

  describe "queries" do
    it "can be run with prove" do
      @theory.prove?(:john.likes :beer).should be_false
      :john.likes! :beer
      @theory.prove?(:john.likes :beer).should be_true
    end

    it "can be run with question mark" do
      :john.likes?(:beer).should be_false
      :john.likes! :beer
      :john.likes?(:beer).should be_true
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

    it "ignore don't-care variables" do
      :john.likes! :beer

      k=[]
      ANYONE.likes(X).each{|x|k << x}
      k.should == [:beer]

      k=[]
      X.likes(ANYTHING).each{|x|k << x}
      k.should == [:john]
    end

    describe "supports Enumerable" do
      before do
        :john.likes! :beer
        :john.likes! :milk
      end

      it "supports all?, any? and none?" do
        (:john.likes A).all?{|a| Symbol===a}.should be_true
        (:john.likes A).all?{|a| a == :beer}.should be_false
        (:john.likes A).all?{|a| a == :beer or a == :milk}.should be_true
        (:john.likes A).any?{|a| a == :beer}.should be_true
        (:john.likes A).any?{|a| a == :milk}.should be_true
        (:john.likes A).any?{|a| a == :water}.should be_false
        (:john.likes A).none?{|a| a == :water}.should be_true
        (:john.likes A).none?{|a| a == :beer}.should be_false
      end

      it "supports to_a" do
        (:john.likes A).to_a.should == [:beer, :water]
      end

      it "supports first" do
        (:john.likes A).first.should == :beer
      end

      it "supports map" do
        (:john.likes A).map{|a|a.to_s}.should == ['beer', 'milk']
      end

      it "supports include? and member?" do
        (:john.likes B).member?(:beer).should be_true
        (:john.likes B).include?(:beer).should be_true
        (:john.likes B).member?(:milk).should be_true
        (:john.likes B).include?(:milk).should be_true
        (:john.likes B).member?(:water).should be_false
        (:john.likes B).include?(:water).should be_false
      end
      
    end

  end

  describe "rules" do
    describe "with prolog body" do
      it "can be asserted with if" do
        :john.is_happy.if :-@.we_have(:beer)
        :john.is_happy?.should be_false
        :-@.we_have!(:beer)
        :john.is_happy?.should be_ture
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

        :john.father! :dad
        :jack.father! :dad
        :dad.father! :grandpa
        :jim.father! :grandpa

        (:john.brother X).to_a.should == [:jack]
        (:john.father X).to_a.should == [:dad]
        (X.father :dad).to_a.should == [:john, :jack]
        (ANY.father X).to_a.should == [:dad, :grandpa]
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
        (4.divides 16).should be_true
        (4.divides 17).should be_false
        (4.divides 18).should be_false
        (3.divides 3).should be_true
        (3.divides 4).should be_false
        (3.divides 5).should be_false
        (3.divides 6).should be_true
      end
    end
  end

  describe "custom classes" do
    before do
      class User
        include Rubylog::Term
        predicate :girl, :boy

        attr_reader name
        def initialize name
          @name = name
        end
        
        def girl?
          name =~ /[aeiouh]$/
        end
        U.boy.unless U.girl
      end
    end

    it "can have ruby predicates" do
      john = User.new "John"
      john.boy?.should be_true
      john.girl?.should be_false
      jane = User.new "Jane"
      jane.boy?.should be_false
      jane.girl?.should be_true
    end




  end

  describe "backtracking" do
    it "works" do

    end
  end



end




