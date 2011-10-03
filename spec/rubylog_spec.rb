require 'rubylog'

Rubylog.use Symbol, :variables
Rubylog.predicate :is_happy, :likes
Rubylog.property :address

describe Rubylog do
  before do
    @theory = Rubylog::Theory.new!
  end

  describe "variables" do
    they "are undefined constants" do 
      [A, SomethingLong].each{|x|x.should be_instance_of Rubylog::Variable}
    end
  end

  describe "don't care variables" do
    they "are variables that start with ANY..." do 
      [ANY, ANYTHING, ANYTIME].each{|x|x.should be_instance_of Rubylog::DontCareVariable}
    end
  end


  describe "terms" do
    they "can be created" do
      (:john.is_happy).should be_instance_of Rubylog::Term
      (:john.likes :beer).should be_instance_of Rubylog::Term
    end
    they "can be indexed" do
      (:john.is_happy)[0].should == :john
      (:john.likes :beer)[0].should == :john
      (:john.likes :beer)[1].should == :beer
    end
  end

  describe "properties" do
    they "can be assigned" do
      :john.address = X
      :john.address.should be_instance_of Rubylog::Variable
    end
  end
  
  describe "facts" do
    they "can be asserted with a bang" do
      :john.is_happy!
      @theory.predicates[:is_happy/1].should contain(:john.is_happy)
      :john.likes! :beer
      @theory.predicates[:likes/2].should contain(:john.likes :beer)
    end

    they "can be asserted with assert" do
      @theory.assert(:john.is_happy)
      @theory.predicates[:is_happy/1].should contain(:john.is_happy)
      @theory.assert(:john.likes :beer)
      @theory.predicates[:likes/2].should contain(:john.likes :beer)
    end
  end

  describe "unification" do
    describe "on terms" do
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
      (:john === :jane).to_a.should == []
    end
  end

  describe "queries" do
    they "can be run with question mark" do
      :john.likes! :beer
      :john.likes?(:beer).should be_true
    end
    they "can be run with prove" do
      :john.likes! :beer
      @theory.prove(:john.likes :beer).should be_true
    end
  end

  describe "rules" do
    describe "with prolog body" do
      they "can be asserted" do
        X.is_happy.if X.likes(Y).and :-@.we_have(Y)
        :john.likes! :beer
        :-@.we_have!(:beer)
        :john.is_happy?.should be
      end
    end

    describe "with ruby body" do
      they "can be asserted" do
        :john.is_happy.if { true }
        :john.is_happy?.should be_true
      end
      they "returns the truth valued of what the block returns" do
        :john.is_happy.if { false }
        :john.is_happy?.should be_false
      end

      they "run the body during query" do
        k = []
        :john.is_happy.if { k << 1 }
        k.should == []
        :john.is_happy?
        k.should == [1]
        :john.is_happy?
        k.should == [1,1]
      end
    end
  end


end
