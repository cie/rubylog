require 'spec_helper'

describe "Dereference" do
  specify do
    t = theory do
      Rubylog::Variable.should === A
      
    end
  end
end
