$:.unshift File.expand_path __FILE__+"/../../lib"
require "rubylog"
require "rubylog/because"

Rubylog.theory "BecauseLogic" do
  include Rubylog::Because

  check []._because_inject(:and, ANY).false
  check [:a]._because_inject(:and, :a)
  check [:a,:b]._because_inject(:and, :a.and(:b))
  check [:a,:b,:c]._because_inject(:and, :a.and(:b.and :c))
  check [:a,:b,:c]._because_inject(:and, (:a.and :b).and(:c)).false

  check :true.because :true
  check :fail.false.because :fail.false

  check :true.and(:true).because :true.and(:true)
  check :true.and(:fail).false.because :fail.false
  check :fail.and(:true).false.because :fail.false
  check :fail.and(:fail).false.because :fail.false.and(:fail.false)

  check :true.or(:true).because :true
  check :true.or(:fail).because :true
  check :fail.or(:true).because :true
  check :fail.or(:fail).false.because :fail.false.and(:fail.false)

  subject Symbol
  implicit
  predicate [:has,2]

  :john.likes! :water

  check :john.likes(:water)
  check :john.likes(:water).because :true
  check :john.likes(A).because :true
  check :john.likes(:milk).false.because :fail.false

  A.drinks(D).if A.likes(D).and A.has(D)

  check :john.drinks(:water).false
  check :john.drinks(:water).false.because(X.and Y).and{p X; p Y}

  :john.has! :water

  check :john.drinks(:water)
  check :john.drinks(:water).because :john.likes(:water).and :john.has(:water)


end
