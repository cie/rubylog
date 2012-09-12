class << Rubylog.theory
  Symbol.rubylog_functor \
    :likes, :is_happy, :in, :has, :we_have,
    :brother, :father, :uncle, :neq, :happy, :%


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
end
