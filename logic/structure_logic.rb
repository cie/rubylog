$:.unshift File.expand_path __FILE__+"/../../lib"
require 'rubylog'

Rubylog.theory "RubylogLogic" do
  subject Symbol
  implicit
  discontinuous [:implements,2], [:supports,2]

  :Assertable.interface!
  :Callable.interface!
  :CompositeTerm.interface!
  :Term.interface!
  :Unifiable.interface!



  :Theory.clazz!
  :Clause.clazz!
  :Predicate.clazz!
  :Variable.clazz!

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

  p (X.implements :Callable).to_a

end

