#!/usr/bin/irb -r

require "rubylog"
require "readline"

Rubylog.use Integer, :implicit_predicates, :variables

while s = Readline.readline("rubylog> ",false)
  Readline::HISTORY.push s unless s.empty?
  begin
    res = eval s
  rescue StandardError
    res = $!
  end

  case res
  when Rubylog::Database
    puts "OK"
  when Rubylog::Clause
    p res
  when true
    puts "Yes."
  when false
    puts "No."
  when nil
  else
    p res
  end
end



