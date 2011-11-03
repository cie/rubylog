require "rubylog"

Rubylog.use :variables, :implicit_predicates, Integer

0.factorial! 1

N.factorial(K).if proc{|n|n>0}.and N1.is {|n,k|k-1}.and N1.factorial(K1).and K.is {|n,k,n1,k1| n*k1}

N.works.if N.factorial(K).and {|n,k|
  puts "#{n} factorial is #{k}"
  true
}

0.works?
1.works?
5.works?



