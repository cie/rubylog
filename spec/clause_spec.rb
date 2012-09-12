require 'rubylog'

class << Rubylog.theory
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
      (:is_happy%1).should be_kind_of Rubylog::Term
      (A%B).should be_kind_of Rubylog::Term
    end
    it "can be asked for their functor" do
      (:john.is_happy).functor.should == :is_happy
      (:is_happy%1).functor.should == :%
      (A%1).functor.should == :%
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
      (:john.is_happy).desc.should == [:is_happy,1]
      (:john.likes :beer).desc.should == [:likes,2]
      (:john.likes :drinking,:beer).desc.should == [:likes,3]
      (:john.likes :drinking.in :bar).desc.should == [:likes,2]
    end
  end

end
