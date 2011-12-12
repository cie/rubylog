=begin

This is a port of this Haskell program

multiply 0 _ = []
multiply n k = k : multiply (n-1) k


dividers n = filter (`divides` n) [1..n] where a `divides` b = b `mod` a == 0
isPerfectNumber n = n == (sum $ dividers n) `div` 2

mirrorList [] = []
mirrorList (a:as) = mirrorList as ++ [a]

intermix [] _ = []
intermix a1@[a] _ = a1
intermix (a:as) b = [a,b] ++ intermix as b

zipPair :: ([a],[b]) -> [(a,b)]
-- zipPair = uncurry zip
zipPair (_,[]) = []
zipPair ([],_) = []
zipPair ((a:as), (b:bs)) = (a,b) : zipPair (as,bs)

=end

class << Rubylog::Theory.new!


  (A.divides B).if {|a,b| b % a==0}
end



