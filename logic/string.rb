load "lib/rubylog/mixins/string.rb"
load "lib/rubylog/variable.rb"
theory do
  check "asdf".is "asdf"
  check { "a#{S}d" =~ /a.S.d/ }
  check { "h#{S}o".is("hello").map{S} == ["ell"] }
  check { "#{Base}.#{Ext}".is("hello.rb").map{Base} == ["hello"] }
  
  check { "#{Base}.#{Ext}".is("hello.rb").map{Ext} == ["rb"] }
  check { "h#{S}o".is("auto").map{S} == [] }

  # backtracked matches
  check { "abc".is("#{A}#{B}").map{"#{A}:#{B}"} == [":abc","a:bc","ab:c","abc:"] }
  check { "www.google.com".is("#{A}.#{B}").map{[A,B]} == [["www", "google.com"],["www.google", "com"]] }
  check { "a".is("#{A}#{B}#{C}").map{"#{A}:#{B}:#{C}"} == ["::a",":a:","a::"] }
  check { "ab".is("#{A}#{B}#{C}").map{"#{A}:#{B}:#{C}"} == %w(::ab :a:b :ab: a::b a:b: ab::) }

  # guards
  check { "abc".is("#{A[/\A.\z/]}#{B}").map{"#{A}:#{B}"} == ["a:bc"] }
  check { "abc".is("#{A[length: 1]}#{B}").map{"#{A}:#{B}"} == ["a:bc"] }

  functor_for String, :palindrome
  S[empty?: true].palindrome!
  S[length: 1].palindrome!
  S[lambda{length > 1}].palindrome.if S.is("#{A[length:1]}#{B}#{A}").and B.palindrome
  prefix_functor :all, :none
  check all  X.in(["", "dd", "aba", "faaf", "ffaaff", "ffffaaffff", "rererer", "lol"]), X.palindrome
  check none X.in(["ji", "doo", "taaaz", "faad", "rerere"]), X.palindrome
end
