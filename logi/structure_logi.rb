:Assertable.interface!
:Callable.interface!
:CompositeTerm.interface!
:Term.interface!
:Unifiable.interface!



:Theory.class!
:Clause.class!
:Predicate.class!
:Variable.class!

:Array.implements! :Unifiable
:Array.implements! :CompositeTerm
:Array.supports! :SecondOrderFunctors
:Clause.implements! :Assertable
:Clause.implements! :Callable
:Clause.implements! :CompositeTerm
:Clause.implements! :Unifiable
:Method.implements! :Callable
:Method.implements! :CompositeTerm
:Object.implements! :Term
:Object.implements! :Unifiable
:Object.supports! :FirstOrderFunctors
:Proc.implements(X).if :Method.implements(X)
:Symbol.implements(X).if :Clause.implements(X)
:Variable.implements! :Callable
:Variable.implements! :Unifiable


:Errors.constant!

kkk
:BUILTINS.constant!
:Cut.constant!


