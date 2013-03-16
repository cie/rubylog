
describe "custom classes" do
  before do
    class User
      rubylog_functor :girl, :boy
      extend Rubylog::Theory
      include Rubylog::DSL::Variables

      attr_reader :name
      def initialize name
        @name = name
      end
      
      U.girl.if { U.name =~ /[aeiouh]$/ }
      U.boy.unless U.girl

      def long_hair?
        girl?
      end

    end
  end

  it "can have ruby predicates" do
    john = User.new "John"
    john.girl?.should be_false
    john.boy?.should be_true
    john.long_hair?.should be_false

    jane = User.new "Jane"
    jane.girl?.should be_true
    jane.boy?.should be_false
    jane.long_hair?.should be_true
  end
  
  it "can be used in assertions" do
    pete = User.new "Pete"
    pete.boy?.should be_false
    pete.boy!
    pete.boy?.should be_true

    User[[:girl,1]].discontiguous!
    janet = User.new "Janet"
    janet.girl?.should be_false
    janet.girl!
    janet.girl?.should be_true
  end




end
