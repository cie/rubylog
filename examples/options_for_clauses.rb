$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

# Options for clauses
# 
# This allows us to add different options to clauses:
#
# :john.likes! :beer, with: :lemon
# :john.likes? :beer                 #=> true
# :john.likes? :beer, with: :snacks  #=> false
#
# A clause has
#   - a functor
#   - an Array of arguments
#   - a Hash of options
#
# A clause unifies with another iff
#   - its functor unifies with the other's AND
#   - its array of arguments unifies with the other's AND
#   - its hash of options unifies with the other's
#
# A hash 'a' unifies with another 'b' iff
#   for every key 'k' in (a.keys+b.keys).uniq
#     - a[k] is not set OR
#     - b[k] is not set OR
#     - a[k] unifies with b[k]
#   

theory "Hashes" do
  subject Symbol, Rubylog::Clause
  functor :likes

  def check_failed *args
    print "F"
  end

  check A.likes(B, with: C).is A.likes(B, with: C)
  check A.likes(B, with: C).is A.likes(B, with: D)
  check A.likes(B, with: :milk).is A.likes(B)
  check A.likes(B, with: :milk).is A.likes(B, with: D)
  check A.likes(B, with: :milk).is A.likes(B, with: D).and D.is :milk
  check (A.likes(B, with: :milk).is A.likes(B, with: :sugar)).false
  check A.likes(B, with: K).is(A.likes(C, with: L)).and K.is(3).and {L == 3}




end
