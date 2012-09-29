$:.unshift File.dirname(__FILE__)+"/../lib"

require 'rubylog'

module Hello
end

Rubylog.theory "Hello::HelloTheory" do
  subject String
  implicit

  X.written.if {|x| puts x}

  :hello.if "Hello, world!".written
end

Hello::HelloTheory.prove :hello

