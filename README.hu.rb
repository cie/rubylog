# Rubylog

# A Rubylog a Prologhoz hasonló programozási nyelv.

# A Prolog program alapköve a funktorból és argumentumokból álló term:
likes("John", "beer")

# A Rubylog programban a funktor az első argumentum után áll:
"John".likes("beer")

# A prolog programot tények és szabályok alkotják.
likes("John", "beer").
drinks(X,D) :- likes(X,D).

# Rubylogban hasonlóan, a tényeket ! jelzi, a szabályokat 'if'
"John".likes! "beer"
X.drinks(D).if X.likes(D)

# A nulláris predikátumok a Rubylogban szimbólumok:
:true
:fail
:cut!

# A Prolog operátorok helyett Rubylogban sokszor szavakat használunk:
#  Prolog   Rubylog
     :-        if
     ,         and
     ;         or
     \+        false
     =         is

# A jobb hangzás érdekében néhány Prolog beépített predikátum neve más
# Rubylogban
#  Prolog   Rubylog
     member    in
# HAsonlít de többet tud

# Vannak
     all
     any
     one
     none

     # Reflection
     list structure follows_from
