=begin

This is a port of some little Haskell programs





zipPair :: ([a],[b]) -> [(a,b)]
-- zipPair = uncurry zip
zipPair (_,[]) = []
zipPair ([],_) = []
zipPair ((a:as), (b:bs)) = (a,b) : zipPair (as,bs)

=end

class << Rubylog::Theory.new!

  rubylog_functor 

  # multiply 0 _ = []
  # multiply n k = k : multiply (n-1) k
  #
  (N.times X, XS).if XS.is{|n,x| n*[x] }


  # dividers n = filter (`divides` n) [1..n `div` 2] 
  #   where a `divides` b = b `mod` a == 0
  # isPerfectNumber n = n == (sum $ dividers n)

  (A.divides B).if {|a,b| b % a == 0}
  (A.divider_of B).if A.in{|a,b| (1..b%2)}.and A.divides B
  (N.perfect_number).if DS.is{|n| (D.divider_of n).to_a }.and DS.sum N
  (L.sum S).if S.is{|l| l.inject(0){|a,b|a+b}}



  # mirrorList [] = []
  # mirrorList (a:as) = mirrorList as ++ [a]
  (L.mirrored M).if M.is{|l|l.reverse}


  # intermix [] _ = []
  # intermix [a] _ = [a]
  # intermix (a:as) b = a:b:intermix as b
  (L.intermix E, M).if M.is{|l,e|l[1..-1].inject [l[0]] {|a,b| a << e << b }}
  # possible:
  #([].intermix ANY, [])
  #([A].intermix ANY, [A])
  #((:|[A,AS]).intermix B, :|[A,B,L]).if (AS.intermix B, L)


end



