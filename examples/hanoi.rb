$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"
extend Rubylog::Context

# Hanoi tower solution

predicate_for Integer, ".move(,,)", ".hanoi"

0.move(ANY,ANY,ANY).if :cut!
N.move(A,B,C).if (
  M.is{N-1}.and \
  M.move(A,C,B).and \
  { puts "move disc #{N} from the #{A} pole to the #{B} pole" or true }.and \
  M.move(C,B,A)
)
N.hanoi.if N.move('left', 'right', 'center')

puts "\nWhat's the solution for a single disc?"
solve 1.hanoi

puts "\n\nWhat's the solution for 5 discs?"
solve 5.hanoi


