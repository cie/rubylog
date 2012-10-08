$:.unshift File.expand_path __FILE__+"/../../lib"
require "rubylog"
require "rubylog/because"

theory "BecauseLogic" do
  include Rubylog::Because

  (:true.because :true).req!
  (:fail.because ANY).false.req!
  (:fail.false.because :true).req!

  (:true.and(:true).because 
     :true.because(:true).and :true.because :true).req!
  (:true.and(:fail).false.because :fail.false.because :true).req!
  (:fail.and(:true).false.because :fail.false.because :true).req!
  (:fail.and(:fail).false.because :fail.false.because(:true).and :fail.false.because :true).req!

  (:true.or(:true).because :true.because(:true).and :true.because :true).req!
  (:fail.false.or(:fail.false).because :fail.false.because(:true).and :fail.false.because :true).req!
  (:true.or(:fail).because :true.because :true).req!
  (:fail.or(:true).because :true.because :true).req!
  (:fail.or(:fail).false.because :fail.false.because :true.and :fail.false.because :true).req!

  subject Symbol
  implicit
  predicate [:has,2]

  :john.likes! :water
  :john.drinks(D).if :john.likes(D)

  check :john.likes(:water)
  (:john.likes(:water).because :true).req!

  check :john.drinks(:water)
  (:john.drinks(:water).because :john.likes(:water).because :true).req!

  check :john.likes(:milk).false
  (:john.likes(:milk).false.because :true).req!

  check :john.drinks(:milk).false
  (:john.drinks(:milk).false.because :john.likes(:milk).false.because :true).req!

end
