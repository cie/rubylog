require 'rubylog'

Rubylog.use Symbol, :variables

describe Rubylog do
  before do
    @theory = Rubylog::Theory.new!
    Rubylog.functor :likes, :is_happy, :/
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
    end
    it "forbids non-predicate names" do
      lambda { :john.something_else }.should raise_error(NoMethodError)
    end
    it "also work with operators" do
      (:is_happy/1).should be_kind_of Rubylog::Term
    end
    it "can be asked for their functor" do
      (:john.is_happy).functor.should == :is_happy
      (:is_happy/1).functor.should == :/
    end
    it "can be indexed" do
      (:john.is_happy)[0].should == :john
      (:john.likes :beer)[0].should == :john
      (:john.likes :beer)[1].should == :beer
    end
    it "support ==" do
      (:john.is_happy).should == (:john.is_happy)
      (:john.is_happy).should_not be_equal(:john.is_happy)
      (:john.is_happy).should_not == nil
      (:john.is_happy).should_not == 9
      (:john.is_happy).should_not == :john
      (:john.is_happy).should_not == Rubylog
    end
    it "support eql?" do
      (:john.is_happy).should be_eql(:john.is_happy)
      (:john.is_happy).should_not be_eql nil
      (:john.is_happy).should_not be_eql 9
      (:john.is_happy).should_not be_eql :john
      (:john.is_happy).should_not be_eql Rubylog
    end
    it "support hash" do
      (:john.is_happy).hash.should == (:john.is_happy).hash
    end
    it "support inspect" do
      (:john.is_happy).inspect.should == ":john.is_happy"
      (:john.likes :beer).inspect.should == ":john.likes(:beer)"
      (:john.likes :drinking,:beer).inspect.should == ":john.likes(:drinking, :beer)"
    end
    it "can tell their arity" do
      (:john.is_happy).arity.should == 1
      (:john.likes :beer).arity.should == 2
      (:john.likes :drinking,:beer).arity.should == 3
    end
  end

  describe "facts" do
    it "can be asserted with assert" do
      @theory.assert(:john.is_happy)
      p @theory.predicates[:is_happy/1]
      @theory.predicates[:is_happy/1].should include(:john.is_happy)
      @theory.assert(:john.likes :beer)
      @theory.predicates[:likes/2].should include(:john.likes :beer)
    end

    it "can be asserted with a bang" do
      :john.is_happy!
      p @theory.predicates
      @theory.predicates[:is_happy/1].should include(:john.is_happy)
      :john.likes! :beer
      @theory.predicates[:likes/2].should include(:john.likes :beer)
    end

  end

  describe "unification" do
    it "works on terms" do
      ((:john.likes :beer) === (A.likes B)).to_a.should == [(:john.likes :beer)]
    end
    it "works for variables" do
      (A === 12).to_a.should == [12]
    end
    it "works for used classes" do
      (:john === X).to_a.should == [:john]
    end
    it "works for constants" do
      (:jane === :jane).to_a.should == [:jane]
    end
    it "fails for different constants" do
      (:john === :jane).to_a.should be_false
    end
  end

  describe "queries" do
    it "can be run with prove" do
      :john.likes! :beer
      @theory.prove(:john.likes :beer).should be_true
    end
    it "can be run with question mark" do
      :john.likes! :beer
      :john.likes?(:beer).should be_true
    end
    it "work with variables" do
      :john.likes?(X).should be_false
      :john.likes! :water
      :john.likes?(X).should be_true
      :john.likes?(X).to_a.should == [[:water]]
    end
    it "yield all solutions" do
      k=[]
      :john.likes! :beer
      :john.likes?(X) do |x|
        k << x
      end
      k.should == [:beer]
    end
    it "ignore don't-care variables" do
      k=[]
      :john.likes! :beer
      ANYONE.likes?(X) do |x|
        k << x
      end
      k.should == [:beer]
    end
  end

  describe "rules" do
    describe "with prolog body" do
      it "can be asserted" do
        X.is_happy.if X.likes(Y).and :-@.we_have(Y)
        :john.likes! :beer
        :-@.we_have!(:beer)
        :john.is_happy?.should be_ture
      end
    end

    describe "with ruby body" do
      it "can be asserted" do
        :john.is_happy.if { true }
        :john.is_happy?.should be_true
      end
      it "returns the truth valued of what the block returns" do
        :john.is_happy.if { false }
        :john.is_happy?.should be_false
      end

      it "run the body during every query" do
        count = 0
        :john.is_happy.if { count += 1 }
        count.should == 0
        :john.is_happy?
        count.should == 1
        :john.is_happy?
        count.should == 2
      end
    end
  end


end

describe "Rubylog with any functor" do
  before do
    @theory = Rubylog::Theory.new!
    Rubylog.any_functor
  end
  it "supports any functor" do
    :john.whatever
  end
end
