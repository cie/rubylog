# encoding: UTF-8
#

puts "Native prolog"

def make_prolog_tree(parent, levels, s="")
  return if levels.zero?

  children = (1..DEGREES).map{random_person} 

  children.each do |child|
    s << "parent_of(#{parent},#{child}).\n"
  end 
  children.each do |child|
    make_prolog_tree(child, levels-1, s)
  end
  s
end 

s = make_prolog_tree(random_person, LEVELS)
s << <<EOT
grandparent_of(A,B) :- parent_of(A,X), parent_of(X,B).

:- dynamic(result/1).

main :- findall([A,B],grandparent_of(A,B),L), assertz(result(L)), halt.

:- initialization(main).
EOT

File.open(File.expand_path(__FILE__+"/../prolog.pl"), "w") do |f|
  f << s
end 

system 'gplc ./examples/benchmark/prolog.pl'
system 'bash -c "time ./examples/benchmark/prolog"'



