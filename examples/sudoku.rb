$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

class Sudoku
  def initialize
    @rows = (1..9).map{(1..9).map{Rubylog::Variable.new}}
  end

  attr_reader :rows
  
  def columns
    @rows.transpose
  end

  def blocks
    (0..2).map {|a| (0..2).map {|b| (0..2).map {|c| (0..2).map {|d| 
      @rows[a*3+c][b*3+d]
    }}.flatten(1) }}.flatten(1)
  end

  extend Rubylog::Context

  predicate_for Array, ".unique"
  L.unique.unless L.is [*ANY, X, *ANY, X, *ANY]

  predicate ".solved .good .shown .given(s)"
  S.solved.if every L.in{S.rows}.and(F.in(L)), F.in(1..9)
  S.good.if S.shown.and all(T.in{[S.rows, S.columns, S.blocks]}.and(L.in{T}), L.unique)

  S.shown.if do
    L.in{S.rows}.each do
      p L
    end
    puts 
  end

  _=ANY
  solve S.is{Sudoku.new}.and lambda{S.rows}.is([
                                     [5,_,_,_,2,4,7,_,_],
                                     [_,_,2,_,_,_,8,_,_],
                                     [1,_,_,7,_,3,9,_,2],
                                     [_,_,8,_,7,2,_,4,9],
                                     [_,2,_,9,8,_,_,7,_],
                                     [7,9,_,_,_,_,_,8,_],
                                     [_,_,_,_,3,_,5,_,6],
                                     [9,6,_,_,1,_,3,_,_],
                                     [_,5,_,6,9,_,_,1,_]
  ]).and S.solved.and S.good.and S.shown rescue p $!
end


