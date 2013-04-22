require "spec_helper"

describe "queries", :rubylog=>true do
  before do
    predicate_for Symbol, ".likes(Drink)"
  end

  it "can be run with true?" do
    true?(:john.likes :beer).should be_false
    :john.likes! :beer
    true?(:john.likes :beer).should be_true
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
    :john.likes! :milk

    k=[]
    (:john.likes X).each{k << X}
    k.should == [:beer, :milk]
  end

  it "yield all solutions with solve" do
    :john.likes! :beer
    :john.likes! :milk

    k=[]
    (:john.likes X).solve{k << X}
    k.should == [:beer, :milk]
  end

  it "yield all solutions with solve and multiple vars and multiple block parameters" do
    :john.likes! :beer
    :jane.likes! :milk
    :jane.likes! :water

    k=[]
    (X.likes Y).solve{k << [X,Y]}
    k.should == [[:john, :beer], [:jane, :milk], [:jane, :water]]
  end

  it "ignore don't-care variables" do
    :john.likes! :beer

    k=[]
    ANYONE.likes(X).each{k << [ANYONE,X]}
    k.should == [[ANYONE, :beer]]

    k=[]
    X.likes(ANYTHING).each{k << [X,ANYTHING]}
    k.should == [[:john, ANYTHING]]
  end

  it "makes sure all variables are instantiated" do
    res = []
    A.likes(B).if {res << A << B }
    A.likes? :beer
    res.should == [nil,:beer]
  end

  it "substitutes deeper variables" do
    res = []
    A.likes(B).if {res << A << B; true}
    (A.is(:john).and B.is(:swimming.in C).and \
     C.is(:sea).and A.likes B).map{[A,B,C]}.should == [[:john,:swimming.in(:sea),:sea]]
     res.should == [:john, :swimming.in(:sea)]
  end


  describe "support Enumerable" do
    before do
      :john.likes! :beer
      :john.likes! :milk
    end

    it "#all?, #any? and #none?" do
      (:john.likes A).all?{Symbol===A}.should be_true
      (:john.likes A).all?{A == :beer}.should be_false
      (:john.likes A).all?{A == :beer or A == :milk}.should be_true
      (:john.likes A).any?{A == :beer}.should be_true
      (:john.likes A).any?{A == :milk}.should be_true
      (:john.likes A).any?{A == :water}.should be_false
      (:john.likes A).none?{A == :water}.should be_true
      (:john.likes A).none?{A == :beer}.should be_false
    end

    it "#to_a" do
      (:john.likes A).to_a.should == [nil, nil]
      (X.likes A).to_a.should == [nil, nil]
      (ANYONE.likes A).to_a.should == [nil, nil]
    end

    it "#map" do
      (:john.likes A).map{A.to_s}.should == ['beer', 'milk']
    end

  end

end
