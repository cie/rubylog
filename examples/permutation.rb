require "rubylog"
module Permutation
  extend Rubylog::Context

  predicate_for Array, ".permutation()"
  # Permutation of a list

  [].permutation! []
  [*FRONT, A, *BACK].permutation([A,*REST]).if [*FRONT,*BACK].permutation(REST)

  [1,2,3,4].permutation(P).each do
    p P
  end


end
