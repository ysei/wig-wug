require File.join(File.dirname(__FILE__), 'astar', 'AMap')

module WigWug
  module Diggers

    class FOOstarDigger < FAstarDigger
      # stash a count of the number of times a position has been visited
      def pick_move
        position = @board.position
        board = @board.instance_variable_get("@board")
        keys = board.keys
        key = keys.find{|k| k == position}

        v = key.instance_variable_get("@visited").to_i
        key.instance_variable_set("@visited", v + 1)

        super
      end

    private

      # cost is normal cost plus the log of the number of visits to that position
      def set_cost k, v
        t = k.instance_variable_get("@visited")
        t ? super + Math::log(t).to_i : super
      end
    end

  end
end

