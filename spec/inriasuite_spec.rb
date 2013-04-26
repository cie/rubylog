require 'spec_helper'

describe "inriasuite", :rubylog=>true do

  describe "abolish", :pending=>"Not supported in Rubylog" do
    specify %([abolish(abolish/1), permission_error(modify,static_procedure,abolish/1)].)
    specify %([abolish(foo/a), type_error(integer,a)].)
    specify %([abolish(foo/(-1)), domain_error(not_less_than_zero,-1)].)
    specify %([(current_prolog_flag(max_arity,A), X is A + 1, abolish(foo/X)), )
    specify %(  representation_error(max_arity)]. )
    specify %(  [abolish(5/2), type_error(atom,5)].)
  end

  describe "and" do
    specify "[','(X=1, var(X)), failure]." do
      X.is(1).and{!X}.to_a.should == [] 
    end
    specify "[','(var(X), X=1), [[X <-- 1]]]." do
      proc{!X}.and(X.is(1)).map{X}.should == [1] 
    end
    specify "[','(fail, call(3)), failure]." do
      :fail.and(proc{raise StopIteration}).true?.should be_false 
    end
    specify "[','(nofoo(X), call(X)), existence_error(procedure, nofoo/1)]." do
      lambda { X.is{proc{raise StopIteration}}.and(X).true? }.should raise_error StopIteration 
    end
    specify "[','(X = true, call(X)), [[X <-- true]]]." do
      X.is(:true).and(X).map{X}.should == [:true] 
    end
  end

  describe "arg", :pending => "Not supported in Rubylog. Use s.structure(predicate, functor, args)" do
    specify "[arg(1,foo(a,b),a), success]."
    specify "[arg(1,foo(a,b),X), [[X <-- a]]]."
    specify "[arg(1,foo(X,b),a), [[X <-- a]]]."
    specify "[arg(2,foo(a, f(X,b), c), f(a, Y)), [[X <-- a, Y <-- b]]]."
    specify "[arg(1,foo(X,b),Y), [[Y <-- X]]]."
    specify "[arg(1,foo(a,b),b), failure]."
    specify "[arg(0,foo(a,b),foo), failure]."
    specify "[arg(3,foo(3,4),N), failure]."
    specify "[arg(X,foo(a,b),a), instantiation_error]."
    specify "[arg(1,X,a), instantiation_error]."
    specify "[arg(0,atom,A), type_error(compound, atom)]."
    specify "[arg(0,3,A), type_error(compound, 3)]. "
    specify "[arg(-3,foo(a,b),A), domain_error(not_less_than_zero,-3)]. "
    specify "[arg(a,foo(a,b),X), type_error(integer, a)]."
  end

  describe "arith_diff" do
    specify "['=\\\\='(0,1), success]." do
      proc{0 != 1}.true?.should be_true
    end
    specify "['=\\\\='(1.0,1), failure]." do
      proc{1.0 != 1}.true?.should be_false
    end
    specify "['=\\\\='(3 * 2,7 - 1), failure]." do
      proc{3*2 != 7-1}.true?.should be_false
    end
    specify "['=\\\\='(N,5), instantiation_error].", :pending=> "this is not an error in Rubylog"
    specify "['=\\\\='(floot(1),5), type_error(evaluable, floot/1)].", :pending=> "this is not an error in Rubylog"
  end

  describe "arith_eq" do
    specify %(['=:='(0,1), failure].) do
      proc{0 == 1}.true?.should be_false
    end
    specify %(['=:='(1.0,1), success].) do
      proc{1.0 == 1}.true?.should be_true
    end
    specify %(['=:='(3 * 2,7 - 1), success].) do
      proc{3*2 == 7-1}.true?.should be_true
    end
    specify %(['=:='(N,5), instantiation_error].), :pending=> "this is not an error in Rubylog"
    specify %(['=:='(floot(1),5), type_error(evaluable, floot/1)].), :pending=> "this is not an error in Rubylog"
    specify %([0.333 =:= 1/3, failure].) do
      proc{0.333 == 1/3}.true?.should be_false
    end
  end

  describe "arith_gt" do
    specify %(['>'(0,1), failure].) do
      proc{0 > 1}.true?.should be_false
    end
    specify %(['>'(1.0,1), failure].) do
      proc{1.0 > 1}.true?.should be_false
    end
    specify %(['>'(3*2,7-1), failure].) do
      proc{3*2 > 7-1}.true?.should be_false
    end
    specify %(['>'(X,5), instantiation_error].) do
      proc { proc{X > 5}.true? }.should raise_error NoMethodError
    end
    specify %(['>'(2 + floot(1),5), type_error(evaluable, floot/1)].) do
      proc { proc{2+4.is(4) > 5}.true? }.should raise_error TypeError
    end
  end

  describe "arith_gt=" do
    specify %(['>='(0,1), failure].) do
      proc{0 >= 1}.true?.should be_false
    end
    specify %(['>='(1.0,1), success].) do
      proc{1.0 >= 1}.true?.should be_true
    end
    specify %(['>='(3*2,7-1), success].) do
      proc{3*2 >= 7-1}.true?.should be_true
    end
    specify %(['>='(X,5), instantiation_error].) do
      proc { proc{X >= 5}.true? }.should raise_error NoMethodError
    end
    specify %(['>='(2 + floot(1),5), type_error(evaluable, floot/1)].) do
      proc { proc{2+4.is(4) >= 5}.true? }.should raise_error TypeError
    end
  end

  describe "arith_lt" do
    specify %(['<'(0,1), success].) do
      proc{0 < 1}.true?.should be_true
    end
    specify %(['<'(1.0,1), failure].) do
      proc{1.0 < 1}.true?.should be_false
    end
    specify %(['<'(3*2,7-1), failure].) do
      proc{3*2 < 7-1}.true?.should be_false
    end
    specify %(['<'(X,5), instantiation_error].) do
      proc { proc{X < 5}.true? }.should raise_error NoMethodError
    end
    specify %(['<'(2 + floot(1),5), type_error(evaluable, floot/1)].) do
      proc { proc{2+4.is(4) < 5}.true? }.should raise_error TypeError
    end
  end

  describe "arith_lt=" do
    specify %(['=<'(0,1), success].) do
      proc{0 <= 1}.true?.should be_true
    end
    specify %(['=<'(1.0,1), success].) do
      proc{1.0 <= 1}.true?.should be_true
    end
    specify %(['=<'(3*2,7-1), success].) do
      proc{3*2 <= 7-1}.true?.should be_true
    end
    specify %(['=<'(X,5), instantiation_error].) do
      proc { proc{X <= 5}.true? }.should raise_error NoMethodError
    end
    specify %(['=<'(2 + floot(1),5), type_error(evaluable, floot/1)].) do
      proc { proc{2+4.is(4) <= 5}.true? }.should raise_error TypeError
    end
  end

  describe "asserta", :pending => "Not supported in Rubylog." do
    specify %([(asserta((bar(X) :- X)), clause(bar(X), B)), [[B <-- call(X)]]].)
    specify %([asserta(_), instantiation_error].)
    specify %([asserta(4), type_error(callable, 4)]. )
    specify %([asserta((foo :- 4)), type_error(callable, 4)]. )
    specify %([asserta((atom(_) :- true)), permission_error(modify,static_procedure,atom/1)].)
  end

  describe "assertz", :pending => "Not supported in Rubylog." do
    specify %([assertz((foo(X) :- X -> call(X))), success].)
    specify %([assertz(_), instantiation_error].)
    specify %([assertz(4), type_error(callable, 4)].)
    specify %([assertz((foo :- 4)), type_error(callable, 4)].)
    specify %([assertz((atom(_) :- true)), )
    specify %(  permission_error(modify,static_procedure,atom/1)].)
  end

  describe "atom", :pending=>"Not supported in Rubylog. Use #is_a?(String) or #is_a?(Symbol)" do
    specify %([atom(atom), success].)
    specify %([atom('string'), success].)
    specify %([atom(a(b)), failure].)
    specify %([atom(Var), failure].)
    specify %([atom([]), success].)
    specify %([atom(6), failure].)
    specify %([atom(3.3), failure].)
  end

  describe "atom_chars", :pending => "Not supported in Rubylog." do
    specify %([atom_chars('',L), [[L <-- []]]].)
    specify %([atom_chars([],L), [[L <-- ['[',']']]]].)
    specify %([atom_chars('''',L), [[L <-- ['''']]]].)
    specify %([atom_chars('iso',L), [[L <-- ['i','s','o']]]].)
    specify %([atom_chars(A,['p','r','o','l','o','g']), [[A <-- 'prolog']]].)
    specify %([atom_chars('North',['N'|X]), [[X <-- ['o','r','t','h']]]].)
    specify %([atom_chars('iso',['i','s']), failure].)
    specify %([atom_chars(A,L), instantiation_error].)
    specify %([atom_chars(A,[a,E,c]), instantiation_error].)
    specify %([atom_chars(A,[a,b|L]), instantiation_error].)
    specify %([atom_chars(f(a),L), type_error(atom,f(a))].)
    specify %([atom_chars(A,iso), type_error(list,iso)].)
    specify %([atom_chars(A,[a,f(b)]), type_error(character,f(b))].)
    specify %([(atom_chars(X,['1','2']), Y is X + 1), type_error(evaluable, '12'/0)].)
  end

  describe "atom_codes", :pending => "Not supported in Rubylog." do
    specify %([atom_codes('',L), [[L <-- []]]].)
    specify %([atom_codes([],L), [[L <-- [ 0'[, 0'] ]]]].)
    specify %([atom_codes('''',L), [[L <-- [ 39 ]]]].)
    specify %([atom_codes('iso',L), [[L <-- [ 0'i, 0's, 0'o ]]]].)
    specify %([atom_codes(A,[ 0'p, 0'r, 0'o, 0'l, 0'o, 0'g]), [[A <-- 'prolog']]].)
    specify %([atom_codes('North',[0'N | L]), [[L <-- [0'o, 0'r, 0't, 0'h]]]].)
    specify %([atom_codes('iso',[0'i, 0's]), failure].)
    specify %([atom_codes(A,L), instantiation_error].)
    specify %([atom_codes(f(a),L), type_error(atom,f(a))].)
    specify %([atom_codes(A, 0'x), type_error(list,0'x)].)
    specify %([atom_codes(A,[ 0'i, 0's, 1000]), representation_error(character_code)]. % 1000 not a code)
  end

  describe "atom_concat" do
    specify %([atom_concat('hello',' world',A), [[A <-- 'hello world']]].) do
      A.is("#{"hello"}#{" world"}").map{A}.should eql ['hello world']
    end
    specify %([atom_concat(T,' world','small world'), [[T <-- 'small']]].) do
      "small world".is("#{T} world").map{T}.should eql ['small']
    end
    specify %([atom_concat('hello',' world','small world'), failure].) do
      "small world".is("#{"hello"}#{" world"}").true?.should be_false
    end
    specify %([atom_concat(T1,T2,'hello'),
              [[T1 <-- '',T2 <-- 'hello'],
              [T1 <-- 'h',T2 <-- 'ello'],
              [T1 <-- 'he',T2 <-- 'llo'],
              [T1 <-- 'hel',T2 <-- 'lo'],
              [T1 <-- 'hell',T2 <-- 'o'],
              [T1 <-- 'hello',T2 <-- '']]]. ) do
              "hello".is("#{A}#{B}").map{[A,B]}.should eql [
                  ['','hello'],
                  ['h','ello'],
                  ['he','llo'],
                  ['hel','lo'],
                  ['hell','o'],
                  ['hello','']]
    end
    specify %(    [atom_concat(A1,'iso',A3), instantiation_error].), :pending=>"This is not an error in Rubylog"
    specify %(    [atom_concat('iso',A2,A3), instantiation_error].), :pending=>"This is not an error in Rubylog"
    specify %(    [atom_concat(f(a),'iso',A3), type_error(atom,f(a))].), :pending=>"This is not an error in Rubylog"
    specify %(    [atom_concat('iso',f(a),A3), type_error(atom,f(a))].), :pending=>"This is not an error in Rubylog"
    specify %(    [atom_concat(A1,A2,f(a)), type_error(atom,f(a))].), :pending=>"This is not an error in Rubylog"
  end

  describe "atom_length", :pending=>"Not supported in Rubylog" do
    specify %([atom_length('enchanted evening', N), [[N <-- 17]]].)
    #specify %(%[atom_length('enchanted\)
     #evening', N), [[N <-- 17]]].)
    specify %([atom_length('', N), [[N <-- 0]]].)
    specify %([atom_length('scarlet', 5), failure].)
    specify %([atom_length(Atom, 4), instantiation_error]. % Culprit Atom)
    specify %([atom_length(1.23, 4), type_error(atom, 1.23)].)
    specify %([atom_length(atom, '4'), type_error(integer, '4')].)
  end

  describe "atomic", :pending=>"There is no such feature in Rubylog. Use !is_a?(Rubylog::CompoundTerm)" do
    specify %([atomic(atom), success].)
    specify %([atomic(a(b)), failure].)
    specify %([atomic(Var), failure].)
    specify %([atomic([]), success].)
    specify %([atomic(6), success].)
    specify %([atomic(3.3), success].)
  end

  describe "bagof" do
    specify %([bagof(X,(X=1;X=2),L), [[L <-- [1, 2]]]].) do
      X.is(1).or(X.is(2)).map{X}.should eql [1,2]
    end
    specify %([bagof(X,(X=1;X=2),X), [[X <-- [1, 2]]]].), :pending=>"This does not work in Rubylog because of dynamic and static contexts" do
      X.is{X.is(1).or(X.is(2)).map{X}}.should eql [1,2]
    end
    specify %([bagof(X,(X=Y;X=Z),L), [[L <-- [Y, Z]]]].), :pending=>"This does not work in Rubylog because of dynamic and static contexts"
    specify %([bagof(X,fail,L), failure].), :pending=>"This does not work in Rubylog because of dynamic and static contexts"
    specify %([bagof(1,(Y=1;Y=2),L), [[L <-- [1], Y <-- 1], [L <-- [1], Y <-- 2]]].), :pending=>"This does not work in Rubylog because of dynamic and static contexts"
    specify %([bagof(f(X,Y),(X=a;Y=b),L), [[L <-- [f(a, _), f(_, b)]]]].) do
      X.is('a').or(Y.is('b')).map{[X,Y]}.should eql [['a',nil],[nil,'b']]
    end
    specify %([bagof(X,Y^((X=1,Y=1);(X=2,Y=2)),S), [[S <-- [1, 2]]]].)
    specify %([bagof(X,Y^((X=1;Y=1);(X=2,Y=2)),S), [[S <-- [1, _, 2]]]].)
    specify %([(set_prolog_flag(unknown, warning), 
       bagof(X,(Y^(X=1;Y=1);X=3),S)), [[S <-- [3]]]].)
    specify %(  [bagof(X,(X=Y;X=Z;Y=1),L), [[L <-- [Y, Z]], [L <-- [_], Y <-- 1]]].)
    specify %(  [bagof(X,Y^Z,L), instantiation_error].)
    specify %(  [bagof(X,1,L), type_error(callable, 1)].)
    specify %(  [findall(X,call(4),S),type_error(callable, 4)].)
  end

  describe "call" do
    specify %([call(!),success].) do
      A.is(:cut!).and(A).true?.should be_true
    end
    specify %([call(fail), failure].) do
      A.is(:fail).and(A).true?.should be_false
    end
    specify %([call((fail, X)), failure].) do
      A.is(:fail.and(X)).and(A).true?.should be_false
    end
    specify %([call((fail, call(1))), failure].) do
      A.is(:fail.and(X.is(1).and(X))).and(A).true?.should be_false
    end
    specify %([call((write(3), X)), instantiation_error].) do
      lambda { A.is(proc{p 3; true}.and(X)).and(A).true? }.should raise_error Rubylog::InstantiationError
    end
    specify %([call((write(3), call(1))), type_error(callable,1)].) do
      lambda { A.is(proc{p 3; true}.and(X.is(1).and(X))).and(A).true? }.should raise_error NoMethodError
    end
    specify %([call(X), instantiation_error].) do
      lambda { A.true? }.should raise_error Rubylog::InstantiationError
    end
    specify %([call(1), type_error(callable,1)].) do
      lambda { A.is(1).and(A).true? }.should raise_error NoMethodError
    end
    specify %([call((fail, 1)), type_error(callable,(fail,1))].), :pending=>"Not an error in Rubylog" do
      # in prolog this raises a type_error, because (fail,1) is compiled at the
      # time of the call() predicate is called. However, in Rubylog currently it
      # is interpreted, so no exception is raised.
      lambda { A.is(:fail.and(1)).and(A).true? }.should raise_error NoMethodError
    end
    specify %([call((write(3), 1)), type_error(callable,(write(3), 1))].) do
      lambda { A.is(proc{p 3; true}.and(1)).and(A).true? }.should raise_error NoMethodError
    end
    specify %([call((1; true)), type_error(callable,(1; true))].) do
      lambda { A.is(Rubylog::Structure.new(A.or(B).predicate, :or, 1, :true)).and(A).true? }.should raise_error NoMethodError
    end
  end

  describe "catch-and-throw", :pending=>"There is no such thing in Rubylog yet. Maybe someday." do
    specify %([(catch(true, C, write('something')), throw(blabla)), system_error]. ) #% The system catchs 'blabla'
    specify %([catch(number_chars(A,L), error(instantiation_error, _), fail), failure].)
  end

  describe "char_code", :pending=>"There is no such feature in Rubylog yet. Maybe someday." do
    specify %([char_code(Char,99),[[Char <-- c]]].)
    specify %([char_code(Char,0'c),[[Char <-- c]]].)
    specify %([char_code(Char,163),[[Char <-- '\xa3\']]].)
    specify %([char_code(b,98),success].)
    specify %([char_code(b,4),failure].)
    specify %([char_code('ab',Code),type_error(character, 'ab')].)
    specify %([char_code(a,x),type_error(integer, x)].)
    specify %([char_code(Char,Code),instantiation_error].)
    specify %([char_code(Char,-2),representation_error(character_code)].)
  end

  describe "clause" do
    specify %([clause(x,Body), failure].) do
      predicate ":x"
      :x.follows_from(Body).true?.should be_false
    end
    specify %([clause(_,B), instantiation_error].) do
      proc { ANY.follows_from(B).true? }.should raise_error Rubylog::InstantiationError
    end
    specify %([clause(4,B), type_error(callable,4)].) do
      proc { A.is(4).and(A.follows_from(B)).true? }.should raise_error NoMethodError
    end
    specify %([clause(f(_),5), type_error(callable,5)].), :pending=>"Not an error in Rubylog" do
      # As Rubylog unifies the second argument with each body in the
      # predicate, this does not lead to an error.
      predicate ".f"
      proc { ANY.f.follows_from(5).true? }.should raise_error NoMethodError
    end
    specify %([clause(atom(_),Body), permission_error(access,private_procedure,atom/1)]. ) do
      proc { ANY.false.follows_from(B).true? }.should raise_error NoMethodError
    end
  end

  describe "compound", :pending=>"There is no such feature in Rubylog. Use is_a?(Rubylog::CompoundTerm)"  do
    specify %([compound(33.3), failure].)
    specify %([compound(-33.3), failure].)
    specify %([compound(-a), success].)
    specify %([compound(_), failure].)
    specify %([compound(a), failure].)
    specify %([compound(a(b)), success].)
    specify %([compound([a]),success].)
  end

  describe "copy_term", :pending=>"Not supported in Rubylog" do
    specify %([copy_term(X,Y), success].)
    specify %([copy_term(X,3), success].)
    specify %([copy_term(_,a), success].)
    specify %([copy_term(a+X,X+b),[[X <-- a]]].)
    specify %([copy_term(_,_), success].)
    specify %([copy_term(X+X+Y,A+B+B),[[B <-- A]]].)
    specify %([copy_term(a,a), success].)
    specify %([copy_term(a,b), failure].)
    specify %([copy_term(f(a),f(X)),[[X <-- a]]].)
    specify %([(copy_term(a+X,X+b),copy_term(a+X,X+b)), failure].)
  end

  describe "current_input", :pending=>"Not supported in Rubylog. Use $stdin" do
    specify %([exists(current_input/1), success].)
  end

  describe "current_output", :pending=>"Not supported in Rubylog. Use $stdout" do
    specify %([exists(current_output/1), success]. )
  end

  describe "current_predicate", :pending=>"There is no such feature in Rubylog yet. Maybe someday." do
    specify %([current_predicate(current_predicate/1), failure]. )
    specify %(/* depends on the test harness */)
    specify %([current_predicate(run_tests/1), success].     )
    specify %([current_predicate(4), type_error(predicate_indicator, 4)].)
    specify %([current_predicate(dog), type_error(predicate_indicator, dog)].)
    specify %([current_predicate(0/dog), type_error(predicate_indicator, 0/dog)].)
  end

  describe "current_prolog_flag", :pending=>"Not supported in Rubylog" do
    specify %([current_prolog_flag(debug, off), success].)
    specify %([(set_prolog_flag(unknown, warning), )
    specify %(  current_prolog_flag(unknown, warning)), success].)
    specify %(  [(set_prolog_flag(unknown, warning), )
    specify %(    current_prolog_flag(unknown, error)), failure].)
    specify %(    [current_prolog_flag(debug, V), [[V <-- off]]].)
    specify %(    [current_prolog_flag(5, V), type_error(atom,5)].)
    specify %(    [current_prolog_flag(warning, V), domain_error(prolog_flag,warning)].)
  end

  describe "cut" do
    specify %([(!,fail;true), failure].) do
      :cut!.and(:fail).or(:true).true?.should be_false
    end
    specify %([(call(!),fail;true), success].) do
      X.is(:cut!).and(X.and(:fail).or(:true)).true?.should be_true
    end
  end

  describe "fail" do
    specify %([fail, failure].) do
      :fail.true?.should be_false
    end
    specify %([undef_pred, existence_error(procedure, undef_pred/0)]. % the value of flag 'unknown' is 'error'.) do
      proc{ :undef_pred.true? }.should raise_error Rubylog::ExistenceError
    end
    specify %([(set_prolog_flag(unknown, fail), undef_pred), failure.), :pending=>"Not supported in Rubylog"
    specify %([(set_prolog_flag(unknown, warning), undef_pred), failure]. % A warning message
              % appears in the outputfile (see forest by: run_forest or bip_forest).), :pending=>"Not supported in Rubylog"
  end

  describe "file_manip", :pending=>"Not supported in Rubylog" do
    specify %(/* by 'run_forest' predicate */)
    specify %([(seek(my_file,3),at(my_file,X)),in(my_file),[[X <-- 3]]].)
    specify %([(seek(my_file,eof),at(my_file,X)),in(my_file),[[X <-- eof]]].)
    specify %([(seek(my_file,3),get_char(X,my_file)),in(my_file),[[X <-- e]]].)
  end

  describe "findall" do
    predicate_for Symbol, ".likes()"

    specify %([findall(X,(X=1 ; X=2),S),[[S <-- [1,2]]]].) do
      check S.is{X.is(1).or(X.is(2)).map{X}}.and{S == [1,2]}
    end
    specify %([findall(X+Y,(X=1),S),[[S <-- [1+_]]]].) do
      check S.is{X.is(:john).map{X.likes(Y)}}.and{S == [:john.likes(Y)]}
    end
    specify %([findall(X,fail,L),[[L <-- []]]].) do
      check G.is(:fail.or :fail).and L.is{G.map{X}}.and{L == []}
    end
    specify %([findall(X,(X=1 ; X=1),S),[[S <-- [1,1]]]].) do
      check S.is{X.is(1).or(X.is(1)).map{X}}.and{S == [1,1]}
    end
    specify %([findall(X,(X=2 ; X=1),[1,2]), failure].) do
      check [1,2].is{X.is(2).or(X.is(1)).map{X}}.false
    end
    specify %([findall(X,(X=1 ; X=2),[X,Y]), [[X <-- 1, Y <-- 2]]].) do
      check [X,Y].is{A.is(1).or(A.is(2)).map{A}}.and{X == 1}.and{Y == 2}
    end
    specify %([findall(X,Goal,S),instantiation_error]. % Culprit Goal) do
      expect {(S.is {Goal.map{X}}).solve}.to raise_error NoMethodError
    end
    specify %([findall(X,4,S),type_error(callable, 4)].) do
      expect {(S.is {4.map{X}}).solve}.to raise_error NoMethodError
    end
  end
  
  describe "float", :pending=>"Not supported in Rubylog. Use is_a? Float" do
    specify %([float(3.3), success].)
    specify %([float(-3.3), success].)
    specify %([float(3), failure].)
    specify %([float(atom), failure].)
    specify %([float(X), failure].)
  end

  describe "functor", :pending=>"Not supported in Rubylog. Use s.structure(predicate, functor, args)" do
    specify %([functor(foo(a,b,c),foo,3), success].)
    specify %([functor(foo(a,b,c),X,Y), [[X <-- foo, Y <-- 3]]].)
    specify %([functor(X,foo,3), [[X <-- foo(A,B,C)]]].  % A, B and C are 3 new variables)
    specify %([functor(X,foo,0), [[X <-- foo]]].)
    specify %([functor(mats(A,B),A,B), [[A <-- mats,B <-- 2]]].)
    specify %([functor(foo(a),foo,2), failure].)
    specify %([functor(foo(a),fo,1), failure].)
    specify %([functor(1,X,Y), [[X <-- 1,Y <-- 0]]].)
    specify %([functor(X,1.1,0), [[X <-- 1.1]]].)
    specify %([functor([_|_],'.',2), success].)
    specify %([functor([],[],0), success].)
    specify %([functor(X, Y, 3), instantiation_error].)
    specify %([functor(X, foo, N), instantiation_error].)
    specify %([functor(X, foo, a), type_error(integer,a)].)
    specify %([functor(F, 1.5, 1), type_error(atom,1.5)].)
    specify %([functor(F,foo(a),1), type_error(atomic,foo(a))].)
    specify %([(current_prolog_flag(max_arity,A), X is A + 1, functor(T, foo, X)), )
    specify %(  representation_error(max_arity)]. )
    specify %(  [functor(T, foo, -1), domain_error(not_less_than_zero,-1)].)
  end

  describe "halt", :pending=>"Not supported in Rubylog" do
    specify %([halt, impl_defined].)
    specify %([halt(1), impl_defined].)
    specify %([halt(a), type_error(integer, a)].)
  end

  describe "if-then", :pending=>"Not supported in Rubylog yet. Maybe someday." do
    specify %(['->'(true, true), success].)
    specify %(['->'(true, fail), failure].)
    specify %(['->'(fail, true), failure].)
    specify %(['->'(true, X=1), [[X <-- 1]]].)
    specify %(['->'(';'(X=1, X=2), true), [[X <-- 1]]]. )
    specify %(['->'(true, ';'(X=1, X=2)), [[X <-- 1], [X <-- 2]]].)
  end

  describe "if-then-else", :pending=>"Not supported in Rubylog yet. Maybe someday." do
    specify %([';'('->'(true, true), fail), success].)
    specify %([';'('->'(fail, true), true), success].)
    specify %([';'('->'(true, fail), fail), failure].)
    specify %([';'('->'(fail, true), fail), failure].)
    specify %([';'('->'(true, X=1), X=2), [[X <-- 1]]].)
    specify %([';'('->'(fail, X=1), X=2), [[X <-- 2]]].)
    specify %([';'('->'(true, ';'(X=1, X=2)), true), [[X <-- 1], [X <-- 2]]].)
    specify %([';'('->'(';'(X=1, X=2), true), true), [[X <-- 1]]].)
  end

  describe "integer", :pending=>"Not supported in Rubylog. Use #is_a?(Integer)" do
    specify %([integer(3), success].)
    specify %([integer(-3), success].)
    specify %([integer(3.3), failure].)
    specify %([integer(X), failure].)
    specify %([integer(atom), failure].)
  end

  describe "is" do
    specify %(['is'(Result,3 + 11.0),[[Result <-- 14.0]]].) do
      Result.is{3+11.0}.map{Result}.should eql [14.0]
    end
    specify %([(X = 1 + 2, 'is'(Y, X * 3)),[[X <-- (1 + 2), Y <-- 9]]]. % error? 1+2), :pending=>"Not supported in Rubylog"
    specify %(['is'(foo,77), failure]. % error? foo), :pending=>"Not supported in Rubylog"
    specify %(['is'(77, N), instantiation_error].), :pending=>"Not supported in Rubylog"
    specify %(['is'(77, foo), type_error(evaluable, foo/0)].), :pending=>"Not supported in Rubylog"
    specify %(['is'(X,float(3)),[[X <-- 3.0]]].) do
      X.is{3.to_f}.map{X}.should eql [3.0]
    end
  end

  describe "nonvar" do
    specify %([nonvar(33.3), success].) do
      X.is(33.3).and{X}.true?.should == true
    end
    specify %([nonvar(foo), success].) do
      X.is(:foo).and{X}.true?.should be_true
    end
    specify %([nonvar(Foo), failure].) do
      X.is(Foo).and{X}.true?.should be_false
    end
    specify %([(foo=Foo,nonvar(Foo)),[[Foo <-- foo]]].) do
      :foo.is(Foo).and(X.is(Foo)).and{X}.true?.should == true
    end
    specify %([nonvar(_), failure].) do
      ANY.is(X).and{X}.true?.should == false
    end
    specify %([nonvar(a(b)), success].) do
      :b.false.is(X).and{X}.true?.should == true
    end
  end

  describe "not_provable" do
    specify %([\+(true), failure].) do
      :true.false.true?.should == false
    end
    specify %([\+(!), failure].) do
      :cut!.false.true?.should == false
    end
    specify %([\+((!,fail)), success].) do
      :cut!.and(:fail).false.true?.should == true
    end
    specify %([((X=1;X=2), \+((!,fail))), [[X <-- 1],[X <-- 2]]].) do
      X.is(1).or(X.is(2)).and(:cut!.and(:fail).false).map{X}.should eql [1,2]
    end
    specify %([\+(4 = 5), success].) do
      4.is(5).false.true?.should == true
    end
    specify %([\+(3), type_error(callable, 3)].) do
      expect { 3.false.true? } .to raise_error NoMethodError
    end
    specify %([\+(X), instantiation_error]. % Culprit X) do
      expect { X.false.true? }.to raise_error  Rubylog::InstantiationError 
    end
  end

  describe "not_unify" do
    specify %(['\\='(1,1), failure].)
    specify %(['\\='(X,1), failure].)
    specify %(['\\='(X,Y), failure].)
    specify %([('\\='(X,Y),'\\='(X,abc)), failure].)
    specify %(['\\='(f(X,def),f(def,Y)), failure].)
    specify %(['\\='(1,2), success].)
    specify %(['\\='(1,1.0), success].)
    specify %(['\\='(g(X),f(f(X))), success].)
    specify %(['\\='(f(X,1),f(a(X))), success].)
    specify %(['\\='(f(X,Y,X),f(a(X),a(Y),Y,2)), success].)
  end

  describe "number" do
    specify %([number(3), success].)
    specify %([number(3.3), success].)
    specify %([number(-3), success].)
    specify %([number(a), failure].)
    specify %([number(X), failure].)
  end

  describe "number_chars" do
    specify %([number_chars(33,L), [[L <-- ['3','3']]]].)
    specify %([number_chars(33,['3','3']), success].)
    specify %([number_chars(33.0,L), [[L <-- ['3','3','.','0']]]].)
    specify %([number_chars(X,['3','.','3','E','+','0']), [[X <-- 3.3]]].)
    specify %([number_chars(3.3,['3','.','3','E','+','0']), success].)
    specify %([number_chars(A,['-','2','5']), [[A <-- (-25)]]].)
    specify %([number_chars(A,['\n',' ','3']), [[A <-- 3]]]. )
    specify %([number_chars(A,['3',' ']), syntax_error(_)].)
    specify %([number_chars(A,['0',x,f]), [[A <-- 15]]].)
    specify %([number_chars(A,['0','''','A']), [[A <-- 65]]].)
    specify %([number_chars(A,['4','.','2']), [[A <-- 4.2]]].)
    specify %([number_chars(A,['4','2','.','0','e','-','1']), [[A <-- 4.2]]].)
    specify %([number_chars(A,L), instantiation_error].)
    specify %([number_chars(a,L), type_error(number, a)].)
    specify %([number_chars(A,4), type_error(list, 4)].)
    specify %([number_chars(A,['4',2]), type_error(character, 2)].)
  end

  describe "number_codes" do
    specify %([number_codes(33,L), [[L <-- [0'3,0'3]]]].)
    specify %([number_codes(33,[0'3,0'3]), success].)
    specify %([number_codes(33.0,L), [[L <-- [51,51,46,48]]]].)
    specify %([number_codes(33.0,[0'3,0'.,0'3,0'E,0'+,0'0,0'1]), success].)
    specify %([number_codes(A,[0'-,0'2,0'5]), [[A <-- (-25)]]].)
    specify %([number_codes(A,[0' ,0'3]), [[A <-- 3]]].)
    specify %([number_codes(A,[0'0,0'x,0'f]), [[A <-- 15]]].)
    specify %([number_codes(A,[0'0,39,0'a]), [[A <-- 97]]].)
    specify %([number_codes(A,[0'4,0'.,0'2]), [[A <-- 4.2]]].)
    specify %([number_codes(A,[0'4,0'2,0'.,0'0,0'e,0'-,0'1]), [[A <-- 4.2]]].)
    specify %([number_codes(A,L), instantiation_error].)
    specify %([number_codes(a,L), type_error(number,a)].)
    specify %([number_codes(A,4), type_error(list,4)].)
    specify %([number_codes(A,[ 0'1, 0'2, 1000]), representation_error(character_code)]. % 1000 not a code)
  end

  describe "once" do
    specify %([once(!), success].)
    specify %([(once(!), (X=1; X=2)), [[X <-- 1],[X <-- 2]]].)
    specify %([once(repeat), success].)
    specify %([once(fail), failure].)
    specify %([once(3), type_error(callable, 3)].)
    specify %([once(X), instantiation_error]. % Culprit X)
  end

  describe "or" do
    specify %([';'(true, fail), success].)
    specify %([';'((!, fail), true), failure].)
    specify %([';'(!, call(3)), success].)
    specify %([';'((X=1, !), X=2), [[X <-- 1]]].)
    specify %([';'(X=1, X=2), [[X <-- 1], [X <-- 2]]].)
  end

  describe "repeat" do
    specify %([(repeat,!,fail), failure].)
  end

  describe "retract" do
    specify %([retract((4 :- X)), type_error(callable, 4)]. )
    specify %([retract((atom(_) :- X == '[]')), )
    specify %(  permission_error(modify,static_procedure,atom/1)].)
  end

  describe "set_prolog_flag" do
    specify %([(set_prolog_flag(unknown, fail),)
    specify %(current_prolog_flag(unknown, V)), [[V <-- fail]]].)
    specify %([set_prolog_flag(X, warning), instantiation_error].)
    specify %([set_prolog_flag(5, decimals), type_error(atom,5)].)
    specify %([set_prolog_flag(date, 'July 1999'), domain_error(prolog_flag,date)].)
    specify %([set_prolog_flag(debug, no), domain_error(flag_value,debug+no)].)
    specify %([set_prolog_flag(max_arity, 40), permission_error(modify, flag, max_arity)].)
    specify %(/* swindles to get tests of double quotes flag to work. */)
    specify %([set_prolog_flag(double_quotes, atom), success].)
    specify %([X = "fred", [[X <-- fred]]].)
    specify %([set_prolog_flag(double_quotes, codes), success].)
    specify %([X = "fred", [[X <-- [102,114,101,100]]]].)
    specify %([set_prolog_flag(double_quotes, chars), success].)
    specify %([X = "fred", [[X <-- [f,r,e,d]]]].)
  end

  describe "setof" do
    specify %([setof(X,(X=1;X=2),L), [[L <-- [1, 2]]]].)
    specify %([setof(X,(X=1;X=2),X), [[X <-- [1, 2]]]].)
    specify %([setof(X,(X=2;X=1),L), [[L <-- [1, 2]]]].)
    specify %([setof(X,(X=2;X=2),L), [[L <-- [2]]]].)
    specify %([setof(X,fail,L), failure].)
    specify %([setof(1,(Y=2;Y=1),L), [[L <-- [1], Y <-- 1], [L <-- [1], Y <-- 2]]].)
    specify %([setof(f(X,Y),(X=a;Y=b),L), [[L <-- [f(_, b), f(a, _)]]]].)
    specify %([setof(X,Y^((X=1,Y=1);(X=2,Y=2)),S), [[S <-- [1, 2]]]].)
    specify %([setof(X,Y^((X=1;Y=1);(X=2,Y=2)),S), [[S <-- [_, 1, 2]]]].)
    specify %([(set_prolog_flag(unknown, warning), )
    specify %(  setof(X,(Y^(X=1;Y=1);X=3),S)), [[S <-- [3]]]].)
    specify %(  [(set_prolog_flag(unknown, warning), )
    specify %(    setof(X,Y^(X=1;Y=1;X=3),S)), [[S <-- [_, 1,3]]]].)
    specify %(    [setof(X,(X=Y;X=Z;Y=1),L), [[L <-- [Y, Z]], [L <-- [_], Y <-- 1]]].)
    specify %(    [setof(X, X^(true; 4),L), type_error(callable,(true;4))].)
    specify %(    [setof(X,1,L), type_error(callable,1)].)
  end

  describe "sub_atom" do
    specify %([sub_atom(abracadabra, 0, 5, _, S2), [[S2 <-- 'abrac']]].)
    specify %([sub_atom(abracadabra, _, 5, 0, S2), [[S2 <-- 'dabra']]].)
    specify %([sub_atom(abracadabra, 3, Length, 3, S2), [[Length <-- 5, S2 <-- 'acada']]].)
    specify %([sub_atom(abracadabra, Before, 2, After, ab), )
    specify %(  [[Before <-- 0, After <-- 9],)
    specify %(    [Before <-- 7, After <-- 2]]].)
    specify %(    [sub_atom('Banana', 3, 2, _, S2), [[S2 <-- 'an']]].)
    specify %(    [sub_atom('charity', _, 3, _, S2), [[S2 <-- 'cha'],)
    specify %(      [S2 <-- 'har'],)
    specify %(      [S2 <-- 'ari'],)
    specify %(      [S2 <-- 'rit'],)
    specify %(      [S2 <-- 'ity']]].)
    specify %(      [sub_atom('ab', Before, Length, After, Sub_atom),)
    specify %(        [[Before <-- 1, Length <-- 0, Sub_atom <-- ''],)
    specify %(          [Before <-- 1, Length <-- 1, Sub_atom <-- 'a'],)
    specify %(          [Before <-- 1, Length <-- 2, Sub_atom <-- 'ab'],)
    specify %(          [Before <-- 2, Length <-- 0, Sub_atom <-- ''],)
    specify %(          [Before <-- 2, Length <-- 1, Sub_atom <-- 'b'],)
    specify %(          [Before <-- 3, Length <-- 0, Sub_atom <-- '']]].)
    specify %(          [sub_atom(Banana, 3, 2, _, S2), instantiation_error].)
    specify %(          [sub_atom(f(a), 2, 2, _, S2), type_error(atom,f(a))].)
    specify %(          [sub_atom('Banana', 4, 2, _, 2), type_error(atom,2)].)
    specify %(          [sub_atom('Banana', a, 2, _, S2), type_error(integer,a)].)
    specify %(          [sub_atom('Banana', 4, n, _, S2), type_error(integer,n)].)
    specify %(          [sub_atom('Banana', 4, _, m, S2), type_error(integer,m)].)
  end

  describe "term_diff" do
    specify %(['\\=='(1,1), failure].)
    specify %(['\\=='(X,X), failure].)
    specify %(['\\=='(1,2), success].)
    specify %(['\\=='(X,1), success].)
    specify %(['\\=='(X,Y), success].)
    specify %(['\\=='(_,_), success].)
    specify %(['\\=='(X,a(X)), success].)
    specify %(['\\=='(f(a),f(a)), failure].)
  end

  describe "term_eq" do
    specify %(['=='(1,1), success].)
    specify %(['=='(X,X), success].)
    specify %(['=='(1,2), failure].)
    specify %(['=='(X,1), failure].)
    specify %(['=='(X,Y), failure].)
    specify %(['=='(_,_), failure].)
    specify %(['=='(X,a(X)), failure].)
    specify %(['=='(f(a),f(a)), success].)
  end

  describe "term_gt" do
    specify %(['@>'(1.0,1), failure].)
    specify %(['@>'(aardvark,zebra), failure].)
    specify %(['@>'(short,short), failure].)
    specify %(['@>'(short,shorter), failure].)
    specify %(['@>'(foo(b),foo(a)), success].)
    specify %(['@>'(X,X), failure].)
    specify %(['@>'(foo(a,X),foo(b,Y)), failure].)
  end

  describe "term_gt=" do
    specify %(['@>='(1.0,1), failure].)
    specify %(['@>='(aardvark,zebra), failure].)
    specify %(['@>='(short,short), success].)
    specify %(['@>='(short,shorter), failure].)
    specify %(['@>='(foo(b),foo(a)), success].)
    specify %(['@>='(X,X), success].)
    specify %(['@>='(foo(a,X),foo(b,Y)), failure].)
  end

  describe "term_lt" do
    specify %(['@<'(1.0,1), success].)
    specify %(['@<'(aardvark,zebra), success].)
    specify %(['@<'(short,short), failure].)
    specify %(['@<'(short,shorter), success].)
    specify %(['@<'(foo(b),foo(a)), failure].)
    specify %(['@<'(X,X), failure].)
    specify %(['@<'(foo(a,X),foo(b,Y)), success].)
  end

  describe "term_lt=" do
    specify %(['@=<'(1.0,1), success].)
    specify %(['@=<'(aardvark,zebra), success].)
    specify %(['@=<'(short,short), success].)
    specify %(['@=<'(short,shorter), success].)
    specify %(['@=<'(foo(b),foo(a)), failure].)
    specify %(['@=<'(X,X), success].)
    specify %(['@=<'(foo(a,X),foo(b,Y)), success].)
  end

  describe "true" do
    specify %([true, success].)
  end

  describe "unify" do
    specify %(['='(X,1),[[X <-- 1]]].)
    specify %(['='(X,Y),[[Y <-- X]]].)
    specify %([('='(X,Y),'='(X,abc)),[[X <-- abc, Y <-- abc]]].)
    specify %(['='(f(X,def),f(def,Y)), [[X <-- def, Y <-- def]]].)
    specify %(['='(1,2), failure].)
    specify %(['='(1,1.0), failure].)
    specify %(['='(g(X),f(f(X))), failure].)
    specify %(['='(f(X,1),f(a(X))), failure].)
    specify %(['='(f(X,Y,X),f(a(X),a(Y),Y,2)), failure].)
    specify %(['='(f(A,B,C),f(g(B,B),g(C,C),g(D,D))),)
    specify %(  [[A <-- g(g(g(D,D),g(D,D)),g(g(D,D),g(D,D))),)
    specify %(    B <-- g(g(D,D),g(D,D)),)
    specify %(    C <-- g(D,D)]]].)
  end

end

