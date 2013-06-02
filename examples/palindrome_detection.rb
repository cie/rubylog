require "rubylog"

module Palindrome
  extend Rubylog::Context
  # Palindrome checking with guards

  predicate_for String, ".palindrome"

  S[length: 0..1].palindrome!
  S.palindrome.if S.is("#{A[length: 1]}#{B}#{A}").and B.palindrome

  check "".palindrome
  check "a".palindrome
  check "aa".palindrome
  check "aba".palindrome
  check "abba".palindrome
  check "ababa".palindrome
  check "ab".palindrome.false
  check "abb".palindrome.false
  check "abbc".palindrome.false
  check "ababab".palindrome.false
end
