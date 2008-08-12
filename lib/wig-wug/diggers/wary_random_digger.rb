require File.join(File.dirname(__FILE__), 'less_random_digger')

module WigWug
  module Diggers

    class WaryRandomDigger < LessRandomDigger
      def pick_move
        move = super

        while @board.look(move).match(/E|G/) do
          dirs ||= ([:up, :down, :left, :right] - [move]).sort_by{rand}
          move = dirs.pop || raise
        end

        move
      end
    end

  end
end

