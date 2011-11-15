require 'rubylog'

FactorialTheory = Rubylog::Theory.new do
  Integer.include_theory self

  predicate :factorial, 2

  0.factorial! 1
  N.factorial(K).if proc{|n|n>0}.and N1.is{|n|n-1}.and N1.factorial(K1).and K.is{|n,_,_,k1| n*k1}

end

Rubylog.use :K

[0,1,2,7].each do |n|
  (n.factorial? K).solve{|k| puts "#{n} factorial is #{k}"}
end

