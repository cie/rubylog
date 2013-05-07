#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)+"/../lib"
# This is a solution for a math problem.
#
# Mafia the black cat plays a game. She has N cups with 0 or 1 mouse under each.
# She peeks under some cups one by one to see if there is a mouse under them.
# What she wants to find out is whether there are two cups next to each other
# which both have a mouse. She found that for some number of cups she has to
# peek under every cup to decide if there are two adjacent ones with a mouse.
# In this case she considers the task hard. For which N's does she consider it
# hard (N<=2013)?

require "rubylog"
require "rubylog/builtins/assumption"
extend Rubylog::Context


class Cup < Struct.new :i
  extend Rubylog::Context

  def inspect
    "##{i}"
  end

  # A cup can be peeked: it has mouse or not
  predicate %w(.peeked .has_mouse .seen )
  C.peeked.if C.has_mouse.assumed.or(:true).and C.seen.assumed

  # A cup can be guessed: it has mouse or not
  predicate %w(.guessed)
  C.guessed.if C.has_mouse.assumed.or(:true)

end


class CupSet
  extend Rubylog::Context

  def initialize n
    @cups = (1..n).map {|i| Cup.new i }
  end

  def each &block
    @cups.each &block
  end

  def [] index
    @cups[index]
  end

  # A set has neighbors if 
  predicate %w(.has_neighbors)
  CS.has_neighbors.if [C,D].in{CS[0..-2].zip(CS[1..-1] || [])}.and C.has_mouse.and D.has_mouse

  # A predicate definitely solves a set if there is no ambiguity
  predicate_for Rubylog::Goal, %w(.definitely_solves())
  T.definitely_solves(CS).if T.any(CS.has_neighbors).and(T.any(CS.has_neighbors.false)).false

  # A trial consist of peeking some cups
  predicate_for Rubylog::Goal, %w(.trial_for())
  T.trial_for(CS).if T.is{C.in(CS).map{C.peeked.or :true}.inject(:true,&:and)}.and T

  # A set is easy if can be definitely solved by a trial that has not seen all
  # cups. A set is had if it cannot.
  predicate %w(.easy() .hard)
  CS.easy(Peeks).if any T.trial_for(CS).and(C.in(CS).all(C.seen).false).definitely_solves(CS).and(Peeks.is{D.in(CS).and(D.peeked).map{D}})
  CS.hard.if CS.easy.false

end


N.in(0..4).each do
  puts "#{N}:"
  CS.is{CupSet.new(N)}.each do

    C.in{CS}.each { p C }
    T.trial_for(CS).each { p T }

    easy = false
    CS.easy(Peeks).each do
      puts "easy: #{Peeks.inspect}"
      easy = true
    end
    puts "hard" if not easy
  end
  puts
end





