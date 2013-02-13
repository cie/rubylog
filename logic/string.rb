load "lib/rubylog/mixins/string.rb"
load "lib/rubylog/variable.rb"
theory do
  check "asdf".is "asdf"
  check { "a#{S}d" =~ /a.S.d/ }
  check { "h#{S}o".is("hello").map{S} == ["ell"] }
  check { "#{Base}.#{Ext}".is("hello.rb").map{Base} == ["hello"] }
  exit
  check { "#{Base}.#{Ext}".is("hello.rb").map{Ext} == ["rb"] }
  check { "h#{S}o".is("auto").map{S} == [] }

  # backtracked matches
  check { "abc".is("#{A}#{B}").map{p "#{A}:#{B}"} == [":abc","a:bc","ab:c","abc:"] }
  check { "www.google.com".is("#{A}.#{B}").map{p [A,B]} == [["www", "google.com"],["www.google", "com"]] }
  check { "a".is("#{A}#{B}#{C}").map{p "#{A}:#{B}:#{C}"} == ["::a",":a:","a::"] }
  check { "ab".is("#{A}#{B}#{C}").map{p "#{A}:#{B}:#{C}"} == %w(::ab :a:b :ab: a::b a:b: ab::) }

  functor_for String, :palindrome
end
