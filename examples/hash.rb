# This code is not supposed to work yet.

check { A.is({x: 4, y: 3}).and B.is({x: X, y:3}).and A.is(B).map{X} == [4] }

check { A.is( x:4, y:3 ).and A.is(x:4, **K).map{K} == [{y:3}] }

