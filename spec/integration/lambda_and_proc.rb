require "spec_helper"

describe "dynamic code" do
  describe "lambda" do
    specify ".is()"     { K.is{4+4}.map{K}.sould == [8] }
    specify ".is(,,)"     { K.is{4+4}.map{K}.sould == [8] }
    specify ".is_not()"
    specify ".in()"     { N.in{1..4}.map{N}.sould == [1,2,3,4] }
    specify ".not_in()"
  end

  describe "proc" do
    specify ".and()"
    specify ".or()"
    specify ".false" { check ->{3>4}.false }
    specify ".all()"
    specify ".iff()"
    specify ".any()"
    specify ".one()"
    specify ".none()"
  end
end
