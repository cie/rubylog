require "rubylog"


Rubylog do
  predicate_for Array, ".on()"

  black, white = 0, 1
  pawn,rook,knight,bishop,queen,king = :pawn, :rook, :knight, :bishop, :queen, :king

  mark = :mark

  signs = {pawn: "p", rook:"r", knight:"n", bishop:"b", queen:"q", king:"k", mark:"x"}

  [black,pawn]  .on! [5,7]
  [black,bishop].on! [8,1]
  [black,pawn]  .on! [8,5]
  [black,king]  .on! [8,6]

  [white,pawn]  .on! [1,7]
  [white,king]  .on! [1,8]
  [white,bishop].on! [2,8]
  [white,pawn]  .on! [3,7]
  [white,pawn]  .on! [5,5]
  [white,pawn]  .on! [6,6]
  [white,knight].on! [6,8]
  [white,bishop].on! [7,2]
  [white,pawn]  .on! [7,7]
  [white,pawn]  .on! [8,4]

  predicate ":show"

  :show.if do
    (R_.in(1..8).and(R.is{9-R_})).each do
      F.in(1..8).each do
        print '.' unless prove [C,P].on([F,R]).and :cut!.and { print C==white ? signs[P].upcase : signs[P]; true }
      end
      puts
    end
    puts
    true
  end

  functor_for Rubylog::Structure, :attacks, :can_move_to
  functor_for Integer, :rook_move, :bishop_move, :squares, :squares_forward
  prefix_functor :knight_move, :pawn_attack, :pawn_move


  [C,king    ].on(S).can_move_to(S1).if   1.  rook_move(S,S1).or 1.bishop_move(S,S1)
  [C,queen   ].on(S).can_move_to(S1).if ANY.  rook_move(S,S1).or ANY.bishop_move(S,S1)
  [C,bishop  ].on(S).can_move_to(S1).if ANY.bishop_move(S,S1)
  [C,knight  ].on(S).can_move_to(S1).if     knight_move(S,S1)
  [C,rook    ].on(S).can_move_to(S1).if ANY.  rook_move(S,S1)

  [white,pawn].on(S).can_move_to(S1).if       pawn_move(S,S1)
  [black,pawn].on(S).can_move_to(S1).if       pawn_move(S1,S)
  [white,pawn].on([F,2]).can_move_to!([F,4])
  [black,pawn].on([F,7]).can_move_to!([F,5])

  [white,pawn].on(S).attacks(S1).if! pawn_attack(S,S1)
  [black,pawn].on(S).attacks(S1).if! pawn_attack(S1,S)
  X.attacks(S1).if X.can_move_to(S1)


  N.squares_forward(A[1..8],B[1..8]).if B.is(A,:+,N)
  N.squares(A,B).if A.in(1..8).and B.in(1..8).and B.is(A,:+,N).or A.is(B,:+,N)

  N.  rook_move([F ,R1],[F ,R2]).if N.squares(R1,R2)
  N.  rook_move([F1,R ],[F2,R ]).if N.squares(F1,F2)
  N.bishop_move([F1,R1],[F2,R2]).if N.squares(R1,R2).and N.squares(F1,F2)

  knight_move([F1,R1],[F2,R2]).if((1.squares(F1,F2).and 2.squares(R1,R2))
                               .or(1.squares(R1,R2).and 2.squares(F1,F2)))
  pawn_move(  [F ,R1],[F ,R2]).if 1.squares_forward(R1,R2)
  pawn_attack([F1,R1],[F2,R2]).if R2.is(R1,:+,1).and 1.squares(F1,F2)


  functor_for Rubylog::Structure, :moved_to

  [C,P].on(S).moved_to(S1).if [C,P].on(S).and [C,P].on(S).can_move_to(S1).and [C,P].on(S).revoked.and [C,P].on(S1).assumed

  solve :show.and [C,P].on(S).moved_to(S1).and{ puts "#{C} #{P}: #{S} -> #{S1}"; true}.and :show






end
