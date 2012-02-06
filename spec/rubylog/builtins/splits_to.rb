require 'rubylog'

class << Rubylog.theory
  describe "splits_to" do
    specify do
      def split_to a,b
        be_splits_to a,b
      end

      [].should_not split_to(ANY,ANY)
      [1].should split_to(1,[])
      [1,2].should split_to(1,[2])
      [1,2,3].should split_to(1,[2,3])

      ([1,2,3].splits_to(B,C)).to_a.should == [[1,[2,3]]]
    end
  end
end
