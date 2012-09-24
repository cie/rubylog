$:.unshift File.dirname(__FILE__)+"/../lib"

require 'rubylog'

module Hello
  Rubylog.theory "HelloTheory" do
    subject String

    :hello.if "Hello, world!"._puts
  end
end

Hello::HelloTheory.prove :hello

