#!/usr/bin/env ruby
require "rubylog"
require "rubylog/builtins/assumption"
extend Rubylog::Theory

functor_for Integer, :easy, :solved, :seen, :peeked, :has

# Mafia the black cat plays a game. She has N cups with 0 or 1 mouse under each.
# She peeks under some cups one by one to see if there is a mouse under them.
# What she wants to find out is whether there are two cups next to each other
# which both have a mouse. She found that for some number of cups she has to
# peek under every cup to decide if there are two adjacent ones with a mouse.
# In this case she considers the task hard. For which N's does she consider it
# hard (N<=2013)?


# There are 0 or 1 mice under each cup.
predicate_for Integer, *%w(.cup() .under())
K.cup.if 0.under(K).or 1.under(K)

# She peeks under a cup to see if there is a mouse under it
predicate_for Integer, ".peeked", ".seen_under()"
K.peeked.if M.in(0..1).and M.seen_under(K).assumed

# She guesses unseen cups
M.thought_under(K).if M.seen_under(K).and :cut!
K.unknown.if ANYTHING.seen_under(K).false

# Two adjacent cups that both have a mouse
[K,L].neighbors.if L.is(K,:+,1).and 1.thought_under(K).and 1.thought_under(L)

# It is solved if two 



N.easy.if(N.solved.and K.in{1..N}.all(K.seen).false)

N.peeked(true).if N.has(true).assumed.and N.seen.assumed
N.peeked(false).if N.has(false).assumed.and N.seen.assumed

0.solved(false)!
1.solved(false)!
2.solved(false).if 2.peeked(false)
2.solved(true).if 2.peeked(true).and 1.peeked(true)

N.in(0..4).each do
  puts "#{N}:"
  N.solved.each do
    puts "solved."
    puts "seen: #{K.seen.map{K}}"
    puts "easy" if K.in{1..N}.all(K.seen).false?
  end
  puts
end
p 0.solved?
p 0.easy?





