require "spec_helper"

describe "file system builtins", :rubylog=>true do
  specify "directories are files" do
    check "./lib".file_in(".")
  end

  specify ": regular files are files" do
    check "./README.rdoc".file_in(".")
  end

  specify ": regular files are not directories" do
    check "./README.rdoc".dir_in(".").false
  end

  specify "#filename_in" do
    check "rubylog.rb".filename_in("lib")
  end

  specify "#dirname_in" do
    check "rubylog".dirname_in("lib")
  end

  specify ": works with variable filename" do
    A.dir_in(".").map{A}.should include "./lib"
  end

  specify ": works with variable dir" do
    "./lib/rubylog.rb".file_in(D).map{D}.should == ["./lib"]
  end

  specify ": works with function dir" do
    FN.file_in{"./lib"}.map{FN}.should include "./lib/rubylog.rb"
  end

  specify ": works with partial strings" do
    "./lib/#{A}.rb".file_in("./lib").map{A}.should == ["rubylog"]
  end

  specify "works with nonvars" do
    "./lib/rubylog.rb".file_in("./lib").to_a.should == [nil]
  end
end
