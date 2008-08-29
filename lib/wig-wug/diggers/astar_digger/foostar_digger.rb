require File.join(File.dirname(__FILE__), 'astar', 'AMap')

module WigWug
  module Diggers

    class FOOstarDigger < FAstarDigger
      def pick_move
        stash_visit_count
        super
      end

    private

      # stash a count of the number of times a position has been visited
      # by attaching an instance variable to the board location key
      def stash_visit_count
        position = @board.position
        board = @board.instance_variable_get("@board")
        keys = board.keys
        key = keys.find{|k| k == position}

        visits = key.instance_variable_get("@visited").to_i
        key.instance_variable_set("@visited", visits + 1)
      end

      # fetch the count of the number of times a position has been visited
      # from the inserted instance variable
      def fetch_visit_count key
        key.instance_variable_get("@visited")
      end

      # cost is normal cost plus the function of the number of visits to that position
      def set_cost key, _
        visits = fetch_visit_count(key)
        visits ? super + visit_weight(visits).to_i : super
      end

      # default visit weight function is to take the log
      def visit_weight visits
        Math::log(visits)
      end
    end

  end
end

