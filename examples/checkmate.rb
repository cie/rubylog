require "./lib/rubylog/builtins/assumption"

theory do
  functor_for Array, :on

  black, white = 0, 1
  pawn,rook,knight,bishop,queen,king = :pawn, :rook, :knight, :bishop, :queen, :king

  signs = {pawn: "p", rook:"r", knight:"n", bishop:"b", queen:"q", king:"k"}

  [black,pawn]  .on! 5,7
  [black,bishop].on! 8,1
  [black,pawn]  .on! 8,5
  [black,king]  .on! 8,6

  [white,pawn]  .on! 1,7
  [white,king]  .on! 1,8
  [white,bishop].on! 2,8
  [white,pawn]  .on! 3,7
  [white,pawn]  .on! 5,5
  [white,pawn]  .on! 6,6
  [white,knight].on! 6,8
  [white,bishop].on! 7,2
  [white,pawn]  .on! 7,7
  [white,pawn]  .on! 8,4


  (R_.in(1..8).and(R.is{9-R_})).each do
    F.in(1..8).each do
      solve ([C,P].on(F,R).and :cut!.and { print C==white ? signs[P].upcase : signs[P] })
        .or { print "." }
    end
    puts
  end
  puts
end
