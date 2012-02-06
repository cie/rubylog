%:-
%
:- op( 20, xfx, <-- ).

main :- 
  open_file,
  repeat,
  (read([Goal, Result]); halt), 
  print_assertion(Goal, Result),
  fail; true.


open_file :-
  argument_list([Filename]),
  open(Filename, read, S),
  set_input(S).


print_assertion(Goal, Result) :-
  write(Goal), write(Result), nl.

:- initialization(main).
