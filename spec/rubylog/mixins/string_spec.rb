require "spec_helper"

describe String, :rubylog=>true do
  describe "unification" do
    check "asdf".is "asdf"
    check { "abc#{S}def" =~ /abc.S\[\].def/ }
    check { "abc#{S[length: 1]}def" =~ /abc.S\[\d+\].def/ }
    check { "h#{S}o".is("hello").map{S} == ["ell"] }
    check { "#{Base}.#{Ext}".is("hello.rb").map{Base} == ["hello"] }
    check { "#{Base}.#{Ext}".is("hello.rb").map{Ext} == ["rb"] }
    check { "h#{S}o".is("auto").map{S} == [] }
  end

  describe "backtracked matches" do
    check { "abc".is("#{A}#{B}").map{"#{A}:#{B}"} == [":abc","a:bc","ab:c","abc:"] }
    check { "www.google.com".is("#{A}.#{B}").map{[A,B]} == [["www", "google.com"],["www.google", "com"]] }
    check { "a".is("#{A}#{B}#{C}").map{"#{A}:#{B}:#{C}"} == ["::a",":a:","a::"] }
    check { "ab".is("#{A}#{B}#{C}").map{"#{A}:#{B}:#{C}"} == %w(::ab :a:b :ab: a::b a:b: ab::) }
  end

  describe "guards" do
    check { "abc".is("#{A[/\A.\z/]}#{B}").map{"#{A}:#{B}"} == ["a:bc"] }
    check { "abc".is("#{A[length: 1]}#{B}").map{"#{A}:#{B}"} == ["a:bc"] }
  end


  describe "palindromes" do
    predicate_for String, ".palindrome"

    S[empty?: true].palindrome!
    S[length: 1].palindrome!
    S[lambda{|s|s.length > 1}].palindrome.if S.is("#{A[length: 1]}#{B}#{A}").and B.palindrome

    check "".palindrome
    check "dd".palindrome
    check "aba".palindrome
    check "faaf".palindrome
    check "ffaaff".palindrome
    check "rererer".palindrome
    check "lol".palindrome
    check "ji".palindrome.false
    check "doo".palindrome.false
    check "taaaz".palindrome.false
    check "faad".palindrome.false
    check "rerere".palindrome.false
  end

end
