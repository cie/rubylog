# encoding: UTF-8
require "rubylog"

module FamilyTree
  extend Rubylog::Context
  predicate_for String, ".parent_of() .grandparent_of()"

  # ki kinek a szülője
  'Bob'.parent_of!('Greg')
  'Greg'.parent_of!('John')
  'Greg'.parent_of!('Jane')

  # "A" nagyszülője B-nek, ha "A" szülője X-nek és X szülője B-nek
  A.grandparent_of(B).if A.parent_of(X).and X.parent_of(B)

  # Az összes nagyszülő-unoka kapcsolat kiírása
  A.grandparent_of(B).each do
    puts "#{A} unokája #{B}."
  end 
end
