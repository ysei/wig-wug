require File.join(File.dirname(__FILE__), 'astar_digger')

module WigWug
  module Diggers

    class FAstarDigger < AstarDigger
      def initialize
        @path = []
        super
      end

      def pick_move
        2.times do
          @path = find_path unless @path.size >= 2
          first = @path.pop; second = @path[-1]

          raise "No StarMap!" unless first and second

          d = :up    if first[1] < second[1]
          d = :down  if first[1] > second[1]
          d = :left  if first[0] > second[0]
          d = :right if first[0] < second[0]
          return d if %w{ R O F }.include?(@board.look(d))

          @path = []
        end

        raise "FOO"
      end
    end

  end
end

