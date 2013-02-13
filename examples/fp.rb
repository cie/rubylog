=begin

This is a port of some little Haskell programs





zipPair :: ([a],[b]) -> [(a,b)]
-- zipPair = uncurry zip
zipPair (_,[]) = []
zipPair ([],_) = []
zipPair ((a:as), (b:bs)) = (a,b) : zipPair (as,bs)

=end
$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

Rubylog.theory "FP" do
  implicit

  # multiply 0 _ = []
  # multiply n k = k : multiply (n-1) k
  #
  (N.times X, XS).if XS.is{|n,x| n*[x] }


  # dividers n = filter (`divides` n) [1..n `div` 2] 
  #   where a `divides` b = b `mod` a == 0
  # isPerfectNumber n = n == (sum $ dividers n)
  #
  class Rubylog::Variable
    def that k
      k.map{rubylog_deep_dereference}
    end
  end

  (A.divides B).if A.in{1..B-1}.and {B%A == 0}
  L.dividers_of(N).if L.list_of(X, X.divides(N))
  
  (N.perfect_number).if N.sum_of ._. dividers_of(N)



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



