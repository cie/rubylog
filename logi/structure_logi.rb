
Rubylog.theory :RubylogLogi do
  include Rubylog::Logi
  subject Symbol
  implicit

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

  :directive.feature_of_theory
  :predicate.feature_of_theory
  :functor.feature_of_theory



  :Errors.constant!
  :BUILTINS.constant!
  :Cut.constant!

  X.has_rb_file_in(Folder).if {|x,folder| File.exists? "#{folder}/#{lib}"}

  make_sure X.interface.all X.has_rb_file_in(:lib)
  make_sure X.interface.all

end
