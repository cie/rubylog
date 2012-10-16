theory "Th" do
  subject Symbol
  functor \
    :likes, :is_happy, :in, :has, :we_have,
    :brother, :father, :uncle, :neq, :happy, :%
end


describe "facts" do
  it "can be asserted with assert" do
    Th.assert(:john.is_happy)
    Th.database[:is_happy][1].should include(Rubylog::Clause.new :-, :john.is_happy, :true)
    Th.assert(:john.likes :beer)
    Th.database[:likes][2].should include(Rubylog::Clause.new :-, :john.likes(:beer), :true)
    Th.assert(:john.likes :drinking.in :bar)
    Th.database[:likes][2].should include(:john.likes(:drinking.in :bar) - :true)
  end

  it "can be asserted with a bang, and it returns the zeroth arg" do
    :john.is_happy!.should == :john
    Th.database[:is_happy][1].should include(:john.is_happy.-:true)
    :john.likes!(:beer).should == :john
    Th.database[:likes][2].should include(:john.likes(:beer).-:true)
    :john.likes!(:drinking.in :bar).should == :john
    Th.database[:likes][2].should include(:john.likes(:drinking.in :bar).-:true)
  end


end
