load "lib/rubylog/mixins/string.rb"
load "lib/rubylog/variable.rb"
theory do
  check "asdf".is "asdf"
  check { "a#{S}d" =~ /a.S.d/ }
  check { "h#{S}o".is("hello").map{S} == ["ell"] }
  check { "#{Base}.#{Ext}".is("hello.rb").map{Base} == ["hello"] }
  check { "#{Base}.#{Ext}".is("hello.rb").map{Ext} == ["rb"] }
  check { "www.google.com".is("#{A}.#{B}").map{[A,B]} == [["www.google", "com"]] }

  functor_for String, :palindrome
end
