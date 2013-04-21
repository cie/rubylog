require "rubylog"
extend Rubylog::Context

predicate_for Array, ".array(N) Peek.matches(Guess)"

[].peek!(0)
[K,*REST].mice(N[thats>0]).if K.in([0,1]).and N.sum_of(N1,1).and REST.mice(N1)

[].seen!([])
[0,*REST].seen([nil,*REST2]).if REST.seen(REST2)
[1,*REST].seen([A,*REST2]).if A.in([0,1]).and REST.seen(REST2)

[].guess!([])
[nil,*REST].guess([A,*REST2]).if A.in([0,1]).and REST.guess(REST2)
[0,*REST].guess([0,*REST2]).if A.in([0,1]).and REST.guess(REST2)
[1,*REST].guess([1,*REST2]).if A.in([0,1]).and REST.guess(REST2)

solve N.is(6).and any Peek.peek(N), all(Peek.seen(Seen), all(Guess.guess(Seen), Guess.has_neighbors.false).or(all(Guess.guess(Seen), Guess.has_neighbors)))

