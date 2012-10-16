$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

theory "RubylogLogic" do
  implicit

  X.clause.if X.fact
  X.clause.if X.rule
  X.clause.if X.query

  X.comment.if X.starts_with('%')

  X.predicate.if X.procedure

  X.procedure.if X.has_many(:clause)


  X.operator.if X.comparison_operator
  X.operator.if X.arithmetic_operator

  X.comparison_operator.if X.arithmetic_comparison_operator.or X.unification_style_operator

  X.unification_style_operator.if X.is :===
  X.unification_style_operator.if X.is :==

  X.arithmetic_comparison_operator.if X.is :<
  X.arithmetic_comparison_operator.if X.is :<=
  X.arithmetic_comparison_operator.if X.is :>
  X.arithmetic_comparison_operator.if X.is :>=

  X.arithmetic_operator.if X.is :+
  X.arithmetic_operator.if X.is :-
  X.arithmetic_operator.if X.is :-@
  X.arithmetic_operator.if X.is :*
  X.arithmetic_operator.if X.is :/
  X.arithmetic_operator.if X.is :%
  X.arithmetic_operator.if X.is :**
  X.arithmetic_operator.if X.is :<=>
  X.arithmetic_operator.if X.is :&
  X.arithmetic_operator.if X.is :|
  X.arithmetic_operator.if X.is :^
  X.arithmetic_operator.if X.is :~
  X.arithmetic_operator.if X.is :<<
  X.arithmetic_operator.if X.is :>>


  X.builtin.if X.is :arg
  X.builtin.if X.is :forget

end

p RubylogLogic.true?{X.builtin.all{X == :arg}}
p RubylogLogic.true?{X.builtin.any{X == :arg}}
p RubylogLogic.true?{X.builtin.one{X == :arg}}
p RubylogLogic.true?{X.builtin.none{X == :arg}}

p RubylogLogic.true?{X.builtin.all{X == :*}}
p RubylogLogic.true?{X.builtin.any{X == :*}}
p RubylogLogic.true?{X.builtin.one{X == :*}}
p RubylogLogic.true?{X.builtin.none{X == :*}}
