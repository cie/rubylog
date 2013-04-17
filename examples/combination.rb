require "rubylog"
extend Rubylog::Context

predicate_for Array, ".choose(,,)"
predicate_for Integer, ".one_less_than()"

N.one_less_than(M).if M.sum_of(N,1)

L.choose!(0,[],L)
[A,*REST].choose(N[thats>0],CHOSEN,[A,*REM]).if REST.choose(N,CHOSEN,REM)
[A,*REST].choose(N[thats>0],[A,*CHOSEN],REM).if N1.one_less_than(N).and REST.choose(N1,CHOSEN,REM)

[1,2,3,4,5].choose(3,L,ANY).each do
  L.choose(1,[A],REM).each do
    puts "#{A}: #{REM}"
  end
end
