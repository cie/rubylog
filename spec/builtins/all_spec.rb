
      describe "all,any,one,none" do
        before do
          :john.likes! :water
          :john.likes! :beer

          :jane.likes! :water
          :jane.likes! :milk
          :jane.likes! :beer

          :jeff.likes! :water
          :jeff.likes! :absinth

          :todd.likes! :milk

          @predicates = [:all, :any, :one, :none]
          @names = :john, :jane, :jeff, :todd
          @good =
            [
              [[1,1,0,0], [0,1,0,0], [0,0,1,0], [0,1,0,1]], # all
              [[1,1,1,0], [1,1,1,1], [1,1,1,0], [0,1,0,1]], # any
              [[0,0,1,0], [0,0,1,1], [1,1,0,0], [0,1,0,1]], # one
              [[0,0,0,1], [0,0,0,0], [0,0,0,1], [1,0,1,0]]  # none
            ]
        end

        it "work" do
          @predicates.map{|p| @names.map{|n| @names.map{|m| 
            (n.likes(K).send p, m.likes(K)).true? ? 1 : 0
          }}}.should == @good
        end

        it "mimic well enumerators' predicates" do
          @predicates.map{|p| @names.map{|n| @names.map{|m|
            n.likes(K).to_a.send(:"#{p}?"){|x| m.likes?(x) } ? 1 : 0
          }}}.should == @good
        end


        
        it "all works" do
          (:john.likes(X).all(:john.likes(X))).should stand
          (:john.likes(X).all(:jane.likes(X))).should stand
          (:john.likes(X).all(:jeff.likes(X))).should_not stand
          (:john.likes(X).all(:todd.likes(X))).should_not stand

          (:jane.likes(X).all(:john.likes(X))).should_not stand
          (:jane.likes(X).all(:jane.likes(X))).should stand
          (:jane.likes(X).all(:jeff.likes(X))).should_not stand
          (:jane.likes(X).all(:todd.likes(X))).should_not stand

          (:jeff.likes(X).all(:john.likes(X))).should_not stand
          (:jeff.likes(X).all(:jane.likes(X))).should_not stand
          (:jeff.likes(X).all(:jeff.likes(X))).should stand
          (:jeff.likes(X).all(:todd.likes(X))).should_not stand

          (:todd.likes(X).all(:john.likes(X))).should_not stand
          (:todd.likes(X).all(:jane.likes(X))).should stand
          (:todd.likes(X).all(:jeff.likes(X))).should_not stand
          (:todd.likes(X).all(:todd.likes(X))).should stand
        end

        it "can be called with global functor syntax" do
          extend Rubylog::DSL::GlobalFunctors
          all(:john.likes(X), :jane.likes(X)).should stand
          all(:jane.likes(X), :john.likes(X)).should_not stand
          any(:jane.likes(X), :todd.likes(X)).should stand
          any(:john.likes(X), :todd.likes(X)).should_not stand
        end

        it "can be called unarily" do
          extend Rubylog::DSL::GlobalFunctors
          one(:john.likes(X)).should_not stand
          one(:jane.likes(X)).should_not stand
          one(:jeff.likes(X)).should_not stand
          one(:todd.likes(X)).should stand
          one(:jim.likes(X)).should_not stand

          any(:john.likes(X)).should stand
          any(:jane.likes(X)).should stand
          any(:jeff.likes(X)).should stand
          any(:todd.likes(X)).should stand
          any(:jim.likes(X)).should_not stand

          all(:john.likes(X)).should stand
          all(:jane.likes(X)).should stand
          all(:jeff.likes(X)).should stand
          all(:todd.likes(X)).should stand
          all(:jim.likes(X)).should stand

          none(:john.likes(X)).should_not stand
          none(:jane.likes(X)).should_not stand
          none(:jeff.likes(X)).should_not stand
          none(:todd.likes(X)).should_not stand
          none(:jim.likes(X)).should stand
        end
      end

    end
