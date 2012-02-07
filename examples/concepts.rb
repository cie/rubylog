
X.clause.if X.fact
X.clause.if X.rule
X.clause.if X.query

X.comment.if X.starts_with('%')

X.predicate.if X.procedure

X.procedure.if X.has_many(clause)


X.operator.if X.comparison_operator
X.operator.if X.arithmetic_operator

X.comparison_operator.if X.arithmetic_comparison_operator.or X.unification_style_operator

X.unification_style_operator.if X === :===
X.unification_style_operator.if X === :==

X.arithmetic_comparison_operator.if X === :<
X.arithmetic_comparison_operator.if X === :<=
X.arithmetic_comparison_operator.if X === :>
X.arithmetic_comparison_operator.if X === :>=

X.arithmetic_operator.if X === :+
X.arithmetic_operator.if X === :-
X.arithmetic_operator.if X === :-@
X.arithmetic_operator.if X === :*
X.arithmetic_operator.if X === :/
X.arithmetic_operator.if X === :%
X.arithmetic_operator.if X === :**
X.arithmetic_operator.if X === :<=>
X.arithmetic_operator.if X === :&
X.arithmetic_operator.if X === :|
X.arithmetic_operator.if X === :^
X.arithmetic_operator.if X === :~
X.arithmetic_operator.if X === :<<
X.arithmetic_operator.if X === :>>




X.builtin.if X === :arg
X.builtin.if X === :forget

