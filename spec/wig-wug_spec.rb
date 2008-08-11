# $Id$

require File.join(File.dirname(__FILE__), %w[spec_helper])

include WigWug

describe WigWug do

  context Board do
    before :each do
      @board = Board.new
    end

    context "initialize method" do
      specify "should set initialized to false" do
        board = Board.new

        board.initialized?.should be_false
      end

      specify "should create empty board hash" do
        board = Board.new

        b = board.instance_variable_get("@board")

        b.is_a?(Hash).should be_true
        b.size.should == 0
      end
    end

    context "update method" do
      specify "should exist" do
        @board.should respond_to("update")
      end

      specify "should take 2 parameters" do
        lambda{ @board.update }.
          should raise_error(ArgumentError)

        lambda{ @board.update([1,0]) }.
          should raise_error(ArgumentError)

        lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
          should_not raise_error

        lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']], nil) }.
          should raise_error(ArgumentError)
      end

      context "first parameter (distance)" do
        specify "should be an array of size 2" do
          lambda{ @board.update(nil, [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error

          lambda{ @board.update([0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error

          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update(['O','O','O'], [['O','P','O'],['O','O','O'],['O','O','O']]) }.
            should raise_error
        end

        specify "should be an array of integers" do
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update(["",0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error

          lambda{ @board.update(["",""], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error

          lambda{ @board.update([0,""], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
        end

        specify "should be an array of positive integers" do
          lambda{ @board.update([1,1], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update([-1,1], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([-1,-1], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,-1], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
        end

        specify "should not be the array [0, 0]" do
          lambda{ @board.update([0,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error

          lambda{ @board.update([1,1], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error
          lambda{ @board.update([0,1], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error
        end
      end

      context "the second parameter (matrix)" do
        specify "should be an array of size 3" do
          lambda{ @board.update([1,0], nil) }.
            should raise_error

          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O']]) }.
            should raise_error

          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O'],['O','O','O']]) }.
            should raise_error
        end

        specify "should be an array of arrays of size 3" do
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
        end

        specify "should be an array of arrays of strings" do
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [[123,'O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P',123],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O',123]]) }.
            should raise_error
        end

        specify "should be an array of arrays of strings of length 1" do
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','O']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['OO','O','O'],['O','P','O'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','OO'],['O','O','O']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['O','O','O'],['O','P','O'],['O','O','OO']]) }.
            should raise_error
        end

        specify "should be an array of arrays of strings 'E', 'F', 'G', 'O', 'P', or 'R'" do
          lambda{ @board.update([1,0], [['E','F','G'],['O','P','R'],['G','F','E']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['E','F','z'],['O','P','R'],['G','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','G'],['O','P','z'],['R','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','R'],['O','P','O'],['G','F','z']]) }.
            should raise_error
        end

        specify "should have exactly one 'P'" do
          lambda{ @board.update([1,0], [['E','F','G'],['O','P','O'],['G','F','E']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['E','F','G'],['O','O','O'],['G','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','G'],['P','P','O'],['G','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','P'],['O','P','O'],['G','F','E']]) }.
            should raise_error
        end

        specify "should have the 'P' in the center (matrix[1][1])" do
          lambda{ @board.update([1,0], [['E','F','G'],['O','P','O'],['G','F','E']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['E','F','P'],['O','O','O'],['G','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','G'],['P','O','O'],['G','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','O'],['O','O','O'],['G','P','E']]) }.
            should raise_error
        end

        specify "should have at most one 'R'" do
          lambda{ @board.update([1,0], [['E','F','G'],['O','P','O'],['G','F','E']]) }.
            should_not raise_error
          lambda{ @board.update([1,0], [['E','R','G'],['O','P','O'],['G','F','E']]) }.
            should_not raise_error
          lambda{ @board.update([1,0], [['E','F','G'],['R','P','O'],['G','F','E']]) }.
            should_not raise_error
          lambda{ @board.update([1,0], [['E','F','G'],['O','P','O'],['G','F','R']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['R','R','P'],['O','O','O'],['G','F','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','R','G'],['P','O','O'],['G','R','E']]) }.
            should raise_error
          lambda{ @board.update([1,0], [['E','F','P'],['R','O','R'],['R','F','E']]) }.
            should raise_error
        end

        specify "should not have the 'R' in the center (matrix[1][1])" do
          lambda{ @board.update([1,0], [['E','F','R'],['O','P','O'],['G','F','E']]) }.
            should_not raise_error
          lambda{ @board.update([1,0], [['E','F','O'],['O','P','O'],['G','F','R']]) }.
            should_not raise_error
          lambda{ @board.update([1,0], [['E','F','O'],['R','P','O'],['G','F','E']]) }.
            should_not raise_error

          lambda{ @board.update([1,0], [['E','F','P'],['O','R','O'],['G','F','E']]) }.
            should raise_error
        end
      end

      context "the first time" do
        specify "call first_time" do
          distance = [1, 1]
          matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

          @board.initialized?.
            should be_false

          @board.should_receive(:first_time).
            with(distance)

          @board.should_receive(:store_board).
            with(matrix)

          @board.should_receive(:possible_destinations)

          @board.update(distance, matrix)
        end
      end

      context "every time" do
        specify "call store_board" do
          distance = [1, 1]
          matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

          @board.initialized?.
            should be_false

          @board.should_receive(:store_board).
            with(matrix)

          @board.update(distance, matrix)
        end

        specify "reduce possible destination list" do
          board = Board.new
          distance = [10, 10]
          matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

          @board.update(distance, matrix)
          @board.destinations.size.should == 4

          @board.move(:left)
          distance = [11, 10]
          @board.update(distance, matrix)
          @board.destinations.size.should == 2

          @board.move(:left)
          distance = [12, 10]
          @board.update(distance, matrix)
          @board.destinations.size.should == 2

          @board.move(:up)
          distance = [12, 9]
          @board.update(distance, matrix)
          @board.destinations.size.should == 1

          @board.move(:right)
          distance = [11, 9]
          @board.update(distance, matrix)
          @board.destinations.size.should == 1

          @board.move(:down)
          distance = [11, 10]
          @board.update(distance, matrix)
          @board.destinations.size.should == 1

          @board.destination.should == [ 10, 10 ]
        end
      end
    end

    context "first_time method" do
      specify "set initialized" do
        @board.initialized?.should be_false

        @board.send("first_time", [1,1])

        @board.initialized?.should be_true
      end

      specify "set the digger position to [0, 0]" do
        @board.position.should == [nil, nil]

        @board.send("first_time", [1,1])

        @board.position.should == [0, 0]
      end

      specify "should raise an exception if already initialized" do
        @board.send("first_time", [1,1])

        lambda{ @board.send("first_time", [1,1]) }.
          should raise_error
      end

      context "potential destinations" do
        before :each do
          @distance = [ rand(100) + 1, rand(100) + 1 ]
          @board.send("first_time", @distance)
        end

        specify "should store 4 destinations" do
          @board.destinations.size.should == 4
        end

        specify "the first destination should be the original distance" do
          distance = [ @distance[0], @distance[1] ]
          @board.destinations[0].should == distance
        end

        specify "the second destination should be the original distance but -x" do
          distance = [ -@distance[0], @distance[1] ]
          @board.destinations[1].should == distance
        end

        specify "the third destination should be the original distance but -x, -y" do
          distance = [ -@distance[0], -@distance[1] ]
          @board.destinations[2].should == distance
        end

        specify "the fourth destination should be the original distance but -y" do
          distance = [ @distance[0], -@distance[1] ]
          @board.destinations[3].should == distance
        end

        context "special cases" do
          before :each do
            @distance = [ rand(100) + 1, rand(100) + 1 ]
            @board = Board.new
          end

          context "x-distance is 0" do
            before :each do
              @distance[0] = 0
              @board.send("first_time", @distance)
            end

            specify "should store 2 destinations" do
              @board.destinations.size.should == 2
            end

            specify "the first destination should be the original distance" do
              distance = [ @distance[0], @distance[1] ]
              @board.destinations[0].should == distance
            end

            specify "the second destination should be the original distance but -y" do
              distance = [ @distance[0], -@distance[1] ]
              @board.destinations[1].should == distance
            end
          end

          context "y-distance is 0" do
            before :each do
              @distance[1] = 0
              @board.send("first_time", @distance)
            end

            specify "should store 2 destinations" do
              @board.destinations.size.should == 2
            end

            specify "the first destination should be the original distance" do
              distance = [ @distance[0], @distance[1] ]
              @board.destinations[0].should == distance
            end

            specify "the second destination should be the original distance but -x" do
              distance = [ -@distance[0], @distance[1] ]
              @board.destinations[1].should == distance
            end
          end
        end
      end
    end

    context "destination" do
      before :each do
        @distance = [ rand(100) + 1, rand(100) + 1 ]
        @board.send("first_time", @distance)
      end

      specify "should be nil while there are multiple potential destinations" do
        @board.destinations.size.should == 4
        @board.destination.should be_nil

        @board.destinations.pop
        @board.destinations.size.should == 3
        @board.destination.should be_nil

        @board.destinations.pop
        @board.destinations.size.should == 2
        @board.destination.should be_nil
      end

      specify "should be the destination when there is one potential destination" do
        3.times{@board.destinations.pop}
        @board.destinations.size.should == 1
        @board.destination.should_not be_nil

        @board.destination.should == @board.destinations[0]
      end

      specify "should be an error if there are no potential destinations" do
        4.times{@board.destinations.pop}
        @board.destinations.size.should == 0

        lambda{ @board.destination }.should raise_error
      end
    end

    context "store_board method" do
      before :each do
        @distance = [ rand(100) + 1, rand(100) + 1 ]
        @board.send("first_time", @distance)

        @matrix = [['O','O','O'],['O','P','O'],['O','O','O']]
        @board.send("store_board", @matrix)
      end

      context "update the board representation" do
        specify "should store the matrix contents centered on the board at position" do
          test = lambda do |board, matrix|
            @board[ [-1,  1] ].
              should == @matrix[0][0]
            @board[ [ 0,  1] ].
              should == @matrix[0][1]
            @board[ [ 1,  1] ].
              should == @matrix[0][2]
            @board[ [-1,  0] ].
              should == @matrix[1][0]
            @board[ [ 0,  0] ].
              should == @matrix[1][1]
            @board[ [ 1,  0] ].
              should == @matrix[1][2]
            @board[ [-1, -1] ].
              should == @matrix[2][0]
            @board[ [ 0, -1] ].
              should == @matrix[2][1]
            @board[ [ 1, -1] ].
              should == @matrix[2][2]
          end

          test.call(@board, @matrix)

          @matrix = [['E','F','G'],['E','P','F'],['E','F','R']]
          @board.send("store_board", @matrix)
          test.call(@board, @matrix)
        end
      end
    end

    context "move method" do
      before:each do
        @board = Board.new
      end

      specify "should exist" do
        @board.should respond_to("move")
      end

      specify "should take 1 parameter" do
        lambda{ @board.move() }.should raise_error(ArgumentError)
        lambda{ @board.move(nil) }.should_not raise_error(ArgumentError)
        lambda{ @board.move(nil,nil) }.should raise_error(ArgumentError)
      end

      specify "the parameter should be :up, :down, :left, or :right" do
        @board.send("first_time", [1,1])

        [ :up, :down, :left, :right ].each do |direction|
          lambda{ @board.move(direction) }.should_not raise_error
        end

        [ nil, "", 1, "foo" ].each do |direction|
          lambda{ @board.move(direction) }.should raise_error
        end
      end

      context "directions" do
        before :each do
          @board.send("first_time", [1,1])
        end

        specify ":up increases the y-position by 1" do
          x = @board.position[0]
          y = @board.position[1]

          (1..5).each do |i|
            @board.move(:up)
            @board.position[1].should == y + i
          end
        end

        specify ":down decreases the y-position by 1" do
          x = @board.position[0]
          y = @board.position[1]

          (1..5).each do |i|
            @board.move(:down)
            @board.position[1].should == y - i
          end
        end

        specify ":left decreases the x-position by 1" do
          x = @board.position[0]
          y = @board.position[1]

          (1..5).each do |i|
            @board.move(:left)
            @board.position[0].should == x - i
          end
        end

        specify ":right increases the x-position by 1" do
          x = @board.position[0]
          y = @board.position[1]

          (1..5).each do |i|
            @board.move(:right)
            @board.position[0].should == x + i
          end
        end
      end
    end
  end

  context Digger do
    context "initialization" do
      specify "should create a Board" do
        Board.should_receive(:new).and_return("NEWBOARD")
        d = Digger.new
        d.instance_variable_get("@board").should == "NEWBOARD"
      end
    end

    context "move! method" do
      before :each do
        @digger = Digger.new
      end

      specify "should exist" do
        @digger.should respond_to("move!")
      end

      specify "should take 2 parameters" do
        lambda{ @digger.move! }.
          should raise_error(ArgumentError)

        lambda{ @digger.move!(nil) }.
          should raise_error(ArgumentError)

        lambda{ @digger.move!(nil, nil) }.
          should_not raise_error(ArgumentError)

        lambda{ @digger.move!(nil, nil, nil) }.
          should raise_error(ArgumentError)
      end

      specify "should use the parameters to update the Board" do
        distance = [1,2]
        matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

        @digger.instance_variable_get("@board").
          should_receive(:update).
          with(distance, matrix)

        @digger.should_receive(:pick_move)

        @digger.instance_variable_get("@board").
          should_receive(:move)

        @digger.move!(distance, matrix)
      end

      specify "should call pick_move to pick the actual move" do
        distance = [1,2]
        matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

        @digger.instance_variable_get("@board").
          should_receive(:update).
          with(distance, matrix)

        @digger.should_receive(:pick_move)

        @digger.instance_variable_get("@board").
          should_receive(:move)

        @digger.move!(distance, matrix)
      end

      specify "should update the Board position with the picked actual move" do
        distance = [1,2]
        matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

        @digger.instance_variable_get("@board").
          should_receive(:update).
          with(distance, matrix)

        @digger.should_receive(:pick_move).and_return("ACTUAL_MOVE")

        @digger.instance_variable_get("@board").
          should_receive(:move).
          with("ACTUAL_MOVE")

        @digger.move!(distance, matrix)
      end

      specify "should return the actual move" do
        distance = [1,2]
        matrix = [['O','O','O'],['O','P','O'],['O','O','O']]

        @digger.instance_variable_get("@board").
          should_receive(:update).
          with(distance, matrix)

        @digger.should_receive(:pick_move).and_return("ACTUAL_MOVE")

        @digger.instance_variable_get("@board").
          should_receive(:move)

        @digger.move!(distance, matrix).should == "ACTUAL_MOVE"
      end
    end

    context "pick_move method" do
      specify "should raise \"OVERRIDE_IN_DIGGER_CLASS\"" do
        digger = Digger.new

        lambda{ digger.send("pick_move") }.
          should raise_error("OVERRIDE_IN_DIGGER_CLASS")
      end
    end
  end

end

# EOF
