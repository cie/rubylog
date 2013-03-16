theory "Th" do
  subject Symbol
  functor \
    :likes, :is_happy, :in, :has, :we_have,
    :brother, :father, :uncle, :neq, :happy, :%, :-
end


describe "facts", :rubylog=>true do
  it "can be asserted with assert" do
    Th.assert(:john.is_happy)
    Th[[:is_happy,1]].should include(Rubylog::Structure.new :-, :john.is_happy, :true)
    Th.assert(:john.likes :beer)
    Th[[:likes,2]].should include(Rubylog::Structure.new :-, :john.likes(:beer), :true)
    Th.assert(:john.likes :drinking.in :bar)
    Th[[:likes,2]].should include(Rubylog::Structure.new :-, :john.likes(:drinking.in :bar), :true)
  end

  it "can be asserted with a bang, and it returns the zeroth arg" do
    :john.is_happy!.should == :john
    Th[[:is_happy,1]].should include(Rubylog::Structure.new(:-, :john.is_happy, :true))
    :john.likes!(:beer).should == :john
    Th[[:likes,2]].should include(Rubylog::Structure.new(:-, :john.likes(:beer), :true))
    :john.likes!(:drinking.in :bar).should == :john
    Th[[:likes,2]].should include(Rubylog::Structure.new(:-, :john.likes(:drinking.in :bar), :true))
  end


end
