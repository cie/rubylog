require "spec_helper"


describe "facts", :rubylog=>true do
  it "can be asserted with assert" do
    subject Symbol
    predicate ".is_happy .likes()"
    functor :in
    assert(:john.is_happy)
    self[[:is_happy,1]].should include(Rubylog::Rule.new :john.is_happy, :true)
    assert(:john.likes :beer)
    self[[:likes,2]].should include(Rubylog::Rule.new :john.likes(:beer), :true)
    assert(:john.likes :drinking.in :bar)
    self[[:likes,2]].should include(Rubylog::Rule.new :john.likes(:drinking.in :bar), :true)
  end

  it "can be asserted with a bang, and it returns the zeroth arg", :rubylog=>true do
    predicate_for Symbol, ".is_happy .likes()"
    :john.is_happy!.should == :john
    self[[:is_happy,1]].should include(Rubylog::Rule.new(:john.is_happy, :true))
    :john.likes!(:beer).should == :john
    self[[:likes,2]].should include(Rubylog::Rule.new(:john.likes(:beer), :true))
    :john.likes!(:drinking.in :bar).should == :john
    self[[:likes,2]].should include(Rubylog::Rule.new(:john.likes(:drinking.in :bar), :true))
  end


end
