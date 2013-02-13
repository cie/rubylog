$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

theory "Trees" do
  subject Integer, Rubylog::Structure
  functor :ch, :pre, :ino

  PRE = [1,2,3,4,5,6,7,8,9,10,11]
  INO = [3,2,6,5,7,4,1,8,10,9,11]

  A.ch(B,C).pre([A,*B1,*C1]).if B.pre(B1).and C.pre(C1)
  A.pre([A]).unless A.is ANY.ch(ANY,ANY)

  A.ch(B,C).ino([*B1,A,*C1]).if B.ino(B1).and C.ino(C1)
  A.ino([A]).unless A.is ANY.ch(ANY,ANY)

  p A.pre(PRE).and(A.ino(INO)).map{A}
  
  p 1.ch(2,3).pre(A).map{A}
end

