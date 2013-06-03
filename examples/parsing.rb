require "readline"

predicate_for String, ".term()", ".expr()", ".atom()"

"#{A}+#{B}".expr(K).if A.expr(I).and B.term(J).and K.is{I+J}
"#{A}-#{B}".expr(K).if A.expr(I).and B.term(J).and K.is{I-J}
A.expr(K).if A.term(K)
"#{A}*#{B}".term(K).if A.atom(I).and B.term(J).and K.is{I*J}
"#{A}/#{B}".term(K).if A.atom(I).and B.term(J).and K.is{I/J}
A.term(K).if A.atom(K)
A[/\A[0-9]+\z/].atom(K).if K.is{A.to_i}
"(#{A})".atom(K).if A.expr(K)

check "5".expr(5)
check "5+3*2".expr(11)
check "1+2+3+4".expr(10)
check "(5+3)/2".expr(4)
check "(5+3(5)/2".expr(ANY).false

puts
while k = Readline.readline("> ", true)
  k.chomp!
  puts k.expr(X).map{X}.first || "error"
end

