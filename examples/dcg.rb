$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'
require 'rubylog/builtins/reflection'
require 'readline'

DrinkingTheory = Rubylog::Theory.new do
  subject String
  functor :likes, :has, :thirsty, :drinks
  check_discontiguous false

  'john'.likes! 'beer'
  'john'.has! 'milk'

  A.drinks(B).if(A.likes(B).and A.has(B))
  A.drinks(B).if A.thirsty.and A.has(B)
end

MyDCG = Rubylog::Theory.new DrinkingTheory do
  functor_for String, :means, :question, :assertion, :phrase, :word, :exec, :write

  "#{P}?".question(X).if P.phrase(X)
  "#{P}.".assertion(X).if P.phrase(X)
  
  "#{A} and #{B}".phrase(X.and Y).if           A.phrase(X).and B.phrase(Y)
  "#{A} or #{B}" .phrase(X.or  Y).if           A.phrase(X).and B.phrase(Y)
  "#{A} if #{B}" .phrase(X.follows_from Y).if  A.phrase(X).and B.phrase(Y)

  "#{A} likes #{B}" .phrase(X.likes(Y)).if  A.word(X).and B.word(Y)
  "#{A} drinks #{B}".phrase(X.drinks(Y)).if A.word(X).and B.word(Y)
  "#{A} has #{B}"   .phrase(X.has(Y)).if    A.word(X).and B.word(Y)

  "#{L}".exec.if L.question(P) .and P.all A.assertion(P).all A.write

  A.write.if { puts A; true }

  A.word(A).if A.is_not ":#{ANY}"
  A.word(B).if A.is ":#{NAME}".and B.variable(NAME)

  [:likes, :has, :drinks].each do |f|
    A.send(f,B).fact.each do
      AS.assertion(A.send(f,B)).each { puts AS; true }
    end
    A.send(f,B).follows_from(T).each do
      AS.assertion(A.send(f,B).follows_from(T)).each { puts AS; true }
    end
  end

  while (line = Readline.readline("-> ", true))
    begin
      prove line.exec or puts "Error."
    rescue
      puts $!
    end
  end


end




