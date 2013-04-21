require "rubylog"
extend Rubylog::Context
predicate_for Array, ".permutation()"

[].permutation! []
[*FRONT, A, *BACK].permutation([A,*REST]).if [*FRONT,*BACK].permutation(REST)

[1,2,3,4].permutation(P).each do
  p P
end


