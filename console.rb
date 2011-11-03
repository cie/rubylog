#!/usr/bin/irb -r

require "rubylog"
require "readline"

Rubylog.use Symbol, Integer, :implicit_predicates, :variables

while s = Readline.readline("rubylog> ",false)
  Readline::HISTORY.push s unless s.empty?
  res = eval s
  case res
  when Rubylog::Database
    puts "OK"
  when Rubylog::Clause
    p res
  when true
    puts "Yes."
  when false
    puts "No."
  else
    p res
  end
end



