require 'spec_helper'

describe "builtin", :rubylog=>true do

  # and
  describe ".and()" do
    specify { X.is(1).and{!X}.to_a.should == [] }
    specify { proc{!X}.and(X.is(1)).map{X}.should == [1] }
    specify { :fail.and(proc{raise StopIteration}).true?.should be_false }
    specify { lambda { X.is{proc{raise StopIteration}}.and(X).true? }.should raise_error StopIteration }
    specify { X.is(:true).and(X).map{X}.should == [:true] }
  end

  # findall
  describe "#map{}" do
    predicate_for Symbol, ".likes()"

    check S.is{X.is(1).or(X.is(2)).map{X}}.and{S == [1,2]}
    check S.is{X.is(:john).map{X.likes(Y)}}.and{S == [:john.likes(Y)]}
    check G.is(:fail.or :fail).and L.is{G.map{X}}.and{L == []}
    check S.is{X.is(1).or(X.is(1)).map{X}}.and{S == [1,1]}
    check [1,2].is{X.is(2).or(X.is(1)).map{X}}.false
    check [X,Y].is{A.is(1).or(A.is(2)).map{A}}.and{X == 1}.and{Y == 2}
    specify { expect {(S.is {Goal.map{X}}).solve}.to raise_error NoMethodError }
    specify { expect {(S.is {4.map{X}}).solve}.to raise_error NoMethodError }
  end

  # call
  describe "Var" do
    specify { A.is(:cut!).and(A).true?.should be_true }
    specify { A.is(:fail).and(A).true?.should be_false }
    specify { A.is(:fail.and(X)).and(A).true?.should be_false }
    specify { A.is(:fail.and(X.is(1).and(X))).and(A).true?.should be_false }
    specify { lambda { A.is(proc{p 3; true}.and(X)).and(A).true? }.should raise_error Rubylog::InstantiationError }
    specify { lambda { A.is(proc{p 3; true}.and(X.is(1).and(X))).and(A).true? }.should raise_error NoMethodError }
    specify { lambda { A.true? }.should raise_error Rubylog::InstantiationError }
    specify { lambda { A.is(1).and(A).true? }.should raise_error NoMethodError }

    # in prolog this raises a type_error, because (fail,1) is compiled at the
    # time of the call() predicate is called. However, in Rubylog currently it
    # is interpreted.
    xspecify { lambda { A.is(:fail.and(1)).and(A).true? }.should raise_error NoMethodError }

    specify { lambda { A.is(proc{p 3; true}.and(1)).and(A).true? }.should raise_error NoMethodError }
    specify { lambda { A.is(Rubylog::Structure.new(A.or(B).predicate, :or, 1, :true)).and(A).true? }.should raise_error NoMethodError }
  end

  # clause
  describe "follows_from" do

    #[clause(x,Body), failure].
    # in Rubylog, predicates must be declared.
    specify { predicate ":x"; :x.follows_from(Body).true?.should be_false }

    #[clause(_,B), instantiation_error].
    specify { proc { ANY.follows_from(B).true? }.should raise_error Rubylog::InstantiationError }

    #[clause(4,B), type_error(callable,4)].
    specify { proc { A.is(4).and(A.follows_from(B)).true? }.should raise_error NoMethodError }

    #[clause(f(_),5), type_error(callable,5)].
    # As Rubylog only unifies the second argument with each body in the
    # predicate, this does not lead to an error.
    xspecify { predicate ".f"; proc { ANY.f.follows_from(5).true? }.should raise_error NoMethodError }

    #[clause(atom(_),Body), permission_error(access,private_procedure,atom/1)]. 
    specify { proc { ANY.false.follows_from(B).true? }.should raise_error NoMethodError }
  end
end

