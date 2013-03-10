
    describe "custom classes" do
      before do
        class User
          rubylog_functor :girl, :boy
          include Rubylog::DSL::Constants

          attr_reader :name
          def initialize name
            @name = name
          end
          
          U.girl.if {|u| u.name =~ /[aeiouh]$/ }
          U.boy.unless U.girl
        end
      end

      it "can have ruby predicates" do
        john = User.new "John"
        john.girl?.should be_false
        john.boy?.should be_true
        jane = User.new "Jane"
        jane.girl?.should be_true
        jane.boy?.should be_false
      end
      
      it "can be used in assertions" do
        pete = User.new "Pete"
        pete.boy?.should be_false
        pete.boy!
        pete.boy?.should be_true

        Rubylog.theory[:girl][1].discontinuous!
        janet = User.new "Janet"
        janet.girl?.should be_false
        janet.girl!
        janet.girl?.should be_true
      end




    end
