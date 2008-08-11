module WigWug
  module Diggers

    class LessRandomDigger < RandomDigger
      def pick_move
        case @board.destinations.size
        when 4
          super
        when 2
          if @board.destinations[0][0] == @board.destinations[1][0]
            super [ :up, :down ]
          else
            super [ :left, :right ]
          end
        when 1
          dirs = 
            [ (@board.position[0] < @board.destination[0] ? :right : :left) ]
          dirs <<
            [ (@board.position[1] < @board.destination[1] ? :up    : :down) ]
          super dirs.flatten
        else
          raise
        end
      end
    end

  end
end

