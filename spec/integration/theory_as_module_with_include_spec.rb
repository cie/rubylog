class MyClass
  include Rubylog::Theory
end

a=MyClass.new

a.amend do
  functor_for Integer, :divides
  (N.divides M).if { M%N == 0 }

  check 23.divides 230
end
