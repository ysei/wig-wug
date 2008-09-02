require File.join(File.dirname(__FILE__), '..', 'digger')

module WigWug
  module Diggers

    class RandomDigger < Digger
      def pick_move directions = [ :up, :down, :left, :right ]
        directions.sort_by{rand}.first
      end
    end

  end
end

