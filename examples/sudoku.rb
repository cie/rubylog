$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

def blocks_of s
  (0..2).map {|a| (0..2).map {|b| (0..2).map {|c| (0..2).map {|d| 
    s[a*3+c][b*3+d]
  }}.flatten(1) }}.flatten(1)
end

predicate_for Array, ".sudoku .row_unique .col_unique .block_unique .unique"

S.sudoku.if S.is([[ANY]*9]*9).and S.row_unique.and S.col_unique.and S.block_unique.and every(ROW.in(S).and(X.in(ROW)), X.in(1..9))

S.row_unique.if every ROW.in(S), ROW.unique
S.col_unique.if every COL.in{S.transpose}, COL.unique
S.col_unique.if every BLOCK.in{blocks_of(S)}, BLOCK.unique

