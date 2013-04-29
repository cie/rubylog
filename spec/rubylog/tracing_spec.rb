require "spec_helper"

describe Rubylog::Tracing, :rubylog=>true do
  before do
    @old_argv = ARGV.dup
    ARGV.replace ["spec/rubylog/tracing_spec.input"]
    @old_stdout = $stdout
    $stdout = @output = StringIO.new
  end

  after do
    Rubylog.trace?.should == false
    $stdout = @old_stdout
    ARGV.replace @old_argv
  end

  it "can be called with true/false" do
    Rubylog.trace true
    1.is(A).solve
    Rubylog.trace false
    @output.string.should include "1.is(A).prove()"
  end

  it "can be called without true" do
    Rubylog.trace 
    1.is(A).solve
    Rubylog.trace false
    @output.string.should include "1.is(A).prove()"
  end

  it "can be called with a block" do
    Rubylog.trace do
      1.is(A).solve
    end
    @output.string.should include "1.is(A).prove()"
  end

  it "traces unifications" do
    Rubylog.trace do
      1.is(A).solve
    end
    @output.string.should include "A.bind_to(1)"
  end
end
