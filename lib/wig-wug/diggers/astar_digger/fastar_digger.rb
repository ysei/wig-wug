require File.join(File.dirname(__FILE__), 'astar', 'AMap')

module WigWug
  module Diggers

    class FAstarDigger < AstarDigger
      def pick_move
        2.times do
          @path ||= StarMapper.new(@board, 20).path
          first = @path.pop; second = @path[-1]

          d = :up    if first[1] < second[1]
          d = :down  if first[1] > second[1]
          d = :left  if first[0] > second[0]
          d = :right if first[0] < second[0]
          return d if %w{ R O F }.include?(@board.look(d))

          @path = nil
        end

        raise "FOO"
      end
    end

  end
end

