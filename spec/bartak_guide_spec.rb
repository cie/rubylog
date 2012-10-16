#!/usr/bin/env ruby
# These are the rubylog transcripts of prolog codes from Roman Barták's Prolog
# guide: http://kti.mff.cuni.cz/~bartak/prolog/

require 'rubylog'


theory "Genealogy" do
  subject Symbol
  functor :man, :woman

  :adam.man!
  :peter.man!
  :paul.man!

  :marry.woman!
  :eve.woman!
end

__END__
theory "Lists" do
  functor_for Object, :head_of
  functor_for Array, :tail_of

  H.head_of(A).if A.splits_to(H,ANY)
  T.tail_of(A).if A.splits_to(ANY,T)

  2.should be_head_of [2,3,4]
  2.should be_head_of [2]
  2.should_not be_head_of [1]
  2.should_not be_head_of []

  [3,4].should be_tail_of [2,3,4]
  [].   should be_tail_of [1]

  Object.rubylog_functor :member_of

  M.member_of(A).if A.splits_to(M,ANY)
  M.member_of(A).if A.splits_to(ANY,T).and M.member_of(T)

  0.should_not be_member_of [1,2,3]
  1.should     be_member_of [1,2,3]
  2.should     be_member_of [1,2,3]
  3.should     be_member_of [1,2,3]
  4.should_not be_member_of [1,2,3]

  Object.rubylog_functor :first_of, :last_of

  F.first_of(A).if A.splits_to(F,ANY)
  L.last_of(A).if A.splits_to(L,[])
  L.last_of(A).if A.splits_to(H,T).and L.last_of(T)

  1.should be_first_of [1,2,3]
  3.should_not be_last_of  []
  3.should be_last_of  [3]
  3.should be_last_of  [2,3]
  3.should be_last_of  [1,2,3]
  1.should_not be_last_of [1,2,3]

  Array.rubylog_functor :prefix_of

  [].prefix_of! ANY_LIST
  A.prefix_of(B).if A.splits_to(H,TA).and B.splits_to(H,TB).and TA.prefix_of(TB)

  [1,2,3].should be_prefix_of [1,2,3]
end


describe "How does it work?" do

  specify "declarative character" do
    (1.in? [1,2,3]).should be_true
    (X.in [1,2,3]).to_a.should == [1,2,3]
    (1.in [X,Y]).to_a.should == [[1,nil], [nil,1]]
    lists = []
    (1.in L).each do |l|
      lists << l
      break if lists.size == 3
    end
    #lists.should == [[1], [nil,1], [nil,nil,1]]
  end
end

end
end

