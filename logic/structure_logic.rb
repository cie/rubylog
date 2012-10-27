$:.unshift File.expand_path __FILE__+"/../../lib"
require 'rubylog'

__END__

Rubylog.theory "RubylogLogic" do
  subject Symbol
  implicit
  discontiguous [:implements,2], [:supports,2]

  :Assertable.interface!
  :Callable.interface!
  :CompositeTerm.interface!
  :Term.interface!
  :Unifiable.interface!



  :Theory.clazz!
  :Structure.clazz!
  :Predicate.clazz!
  :Variable.clazz!

  :Array.implements! :Unifiable
  :Array.implements! :CompositeTerm
  :Array.supports! :SecondOrderFunctors
  :Structure.implements! :Assertable
  :Structure.implements! :Callable
  :Structure.implements! :CompositeTerm
  :Structure.implements! :Unifiable
  :Method.implements! :CompositeTerm
  :Object.implements! :Term
  :Object.implements! :Unifiable
  :Object.supports! :FirstOrderFunctors
  :Proc.implements(X).if :Method.implements(X)
  :Symbol.implements(X).if :Structure.implements(X)
  :Variable.implements! :Callable
  :Variable.implements! :Unifiable

  :directive.feature_of_theory
  :predicate.feature_of_theory
  :functor.feature_of_theory





  :Errors.constant!
  :BUILTINS.constant!
  :Cut.constant!

  X.has_rb_file_in(Folder).if {|x,folder| File.exists? "#{folder}/#{lib}"}

  check {(X.implements :Callable).map{X}.sort == [:Structure, :Method]}

end

