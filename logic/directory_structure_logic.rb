$:.unshift File.expand_path __FILE__+"/../../lib"
require "rubylog"
require "rubylog/builtins/fs"

theory do
  subject String
  functor :dir, :contains
  check_discontiguous false

  "examples".dir!.contains! "examples and ideas for different applications of Rubylog"
  "lib".dir!.contains! "source code of Rubylog"
  "spec".dir!.contains! "functional tests written in RSpec"
  "logic".dir!.contains! "integration tests written in Rubylog"

  gitignore = File.open(".gitignore"){|f|f.read}.split("\n")
  check X.dir.equiv(X.dir_in(".").and X.in(gitignore).false)
end

