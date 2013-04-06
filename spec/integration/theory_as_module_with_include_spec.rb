require "spec_helper"

class MyClass
  include Rubylog::Context
end

a=MyClass.new

a.amend do
  predicate_for Integer, %w(.divides())
  (N.divides M).if { M%N == 0 }

  check 23.divides 230
end
