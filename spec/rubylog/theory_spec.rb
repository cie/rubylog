require "spec_helper"

Rubylog.theory "Th" do
  subject Symbol
  predicate %w".is_happy .likes()"
  functor :in
end


describe "facts", :rubylog=>true do
  it "can be asserted with assert" do
    Th.assert(:john.is_happy)
    Th[[:is_happy,1]].should include(Rubylog::Rule.new :john.is_happy, :true)
    Th.assert(:john.likes :beer)
    Th[[:likes,2]].should include(Rubylog::Rule.new :john.likes(:beer), :true)
    Th.assert(:john.likes :drinking.in :bar)
    Th[[:likes,2]].should include(Rubylog::Rule.new :john.likes(:drinking.in :bar), :true)
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
