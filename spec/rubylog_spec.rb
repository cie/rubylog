require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec::Matchers.define :stand do 
  match do |actual|
    actual.true?
  end
end


class << Rubylog.theory
  Symbol.rubylog_functor \
    :likes, :is_happy, :in, :has, :we_have,
    :brother, :father, :uncle, :neq, :happy, :%
  Integer.rubylog_functor :divides, :queens
  Rubylog::Clause.rubylog_functor :-

  describe Rubylog do
    before do
      Rubylog.theory.clear
    end











    describe "builtin" do
















  end


end







