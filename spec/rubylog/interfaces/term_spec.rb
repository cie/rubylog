
describe "unification", :rubylog=>true do
  predicate_for Symbol, ".likes"

  it "works for variables" do
    result = false
    A.rubylog_unify(12) { result = true }
    result.should == true
  end
  it "works for used classes" do
    result = false
    :john.rubylog_unify(A) { result = true }
    result.should == true
  end
  it "works for constants" do
    result = false
    :john.rubylog_unify(:john) { result = true }
    result.should == true
  end
  it "fails for different constants" do
    result = false
    :john.rubylog_unify(:mary) { result = true }
    result.should == false
  end
  it "works on clauses" do
    result = false
    (:john.likes :beer).rubylog_unify(A.likes B) { result = true }
    result.should == true
  end
  it "works on clauses with equal values" do
    result = false
    (:john.likes :beer).rubylog_unify(:john.likes :beer) { result = true }
    result.should == true
  end
  it "works on clauses with different values" do
    result = false
    (:john.likes :beer).rubylog_unify(:john.likes :milk) { result = true }
    result.should == false
  end
  it "works on clauses with variables and equal values" do
    result = false
    (:john.likes :beer).rubylog_unify(X.likes :beer) { result = true }
    result.should == true
  end
  it "works on clauses with variables and equal values #2" do
    result = false
    (:john.likes :beer).rubylog_unify(:john.likes DRINK) { result = true }
    result.should == true
  end
  it "works on clauses with variables and different values" do
    result = false
    (:john.likes :beer).rubylog_unify(X.likes :milk) { result = true }
    result.should == false
  end
  it "works on clauses with variables and different values #2" do
    result = false
    (:john.likes :beer).rubylog_unify(:jane.likes D) { result = true }
    result.should == false
  end

  it "works on clauses with repeated variables #1" do
    result = false
    (A.likes A).rubylog_compile_variables.rubylog_unify(:john.likes :jane) { result = true }
    result.should == false
    (A.likes A).rubylog_compile_variables.rubylog_unify(:john.likes :john) { result = true }
    result.should == true
  end
  it "works on clauses with repeated variables #1" do
    result = false
    (:john.likes :jane).rubylog_unify(A.likes(A).rubylog_compile_variables) { result = true }
    result.should == false
    (:john.likes :john).rubylog_unify(A.likes(A).rubylog_compile_variables) { result = true }
    result.should == true
  end

  it "works for second-order variables" do
    result = false
    (:john.likes :beer).rubylog_unify(A) { result = true }
    result.should == true
  end

end
