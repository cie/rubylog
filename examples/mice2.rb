require "rubylog"
extend Rubylog::Context

predicate_for Rubylog::Variable, ".bound"
A.bound.if { A.is_a? Rubylog::Variable }

class Array
  extend Rubylog::Context

  predicate ".can_have_neighbours"
  [*ANY,:yes,:yes,*ANY].can_have_neighbours!

  predicate ".has_neighbours"
  [*ANY,A,B,*ANY].has_neighbours.if { A == :yes && B == :yes}

  predicate ".cannot_have_neighbours"
  A.cannot_have_neighbours.if A.can_have_neighbours.false

  predicate ".decidable"
  A.decidable.if A.has_neighbours.or A.cannot_have_neighbours


  predicate ".guessed"
  A.guessed.if every X.in(A), X.is(:yes).or(X.is(:no)).or(:true)

  predicate ".easy"
  A.easy.if A.guessed.and A.decidable.and any X.in(A), X.bound.false

  Rubylog.trace
  N.in(0..6).each do
    puts "#{N}: #{([ANY]*N).easy?}"
  end 

end 



