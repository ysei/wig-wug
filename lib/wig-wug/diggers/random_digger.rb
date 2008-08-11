module WigWug
  module Diggers

    class RandomDigger < Digger
      def pick_move
        [ :up, :down, :left, :right ].sort_by{rand}.first
      end
    end

  end
end

