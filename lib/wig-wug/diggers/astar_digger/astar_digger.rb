require File.join(File.dirname(__FILE__), 'astar', 'AMap')

module WigWug
  module Diggers

    class AstarDigger < Digger
      class StarMapper
        attr_accessor :path

        def initialize(board, timeout = 30)
          b = board.instance_variable_get("@board")
          k = b.keys
          xs = (k.map{|z| z[0]} << board.destinations[0][0]).sort
          ys = (k.map{|z| z[1]} << board.destinations[0][1]).sort
          x_offset = xs.first - 1
          y_offset = ys.first - 1
          x_size = xs.last - xs.first + 3
          y_size = ys.last - ys.first + 3
          cmap = Array.new(y_size){Array.new(x_size){1}}
          b.each do |k, v|
            case v
            when 'F'
              cmap[k[1] - y_offset][k[0] - x_offset] = 2
            when 'E'
              cmap[k[1] - y_offset][k[0] - x_offset] = 0
            when 'G'
              cmap[k[1] - y_offset][k[0] - x_offset] = 0
            else
              #
            end
          end
          start = [ board.position[0] - x_offset, board.position[1] - y_offset ]
          finish = [ board.destinations[0][0] - x_offset, board.destinations[0][1] - y_offset ]
          amap = ::AStar::AMap.new(cmap)
          player = amap.co_ord(start[0], start[1])
          ruby = amap.co_ord(finish[0], finish[1])
          route = amap.astar(player, ruby, timeout)
          path = []
          current = route
          while current.parent do
            path << current
            current = current.parent
          end
          @path =  path.map{|n| [n.x, n.y]} << start
          puts amap.show_path(route) if $DEBUG
        end
      end

      def pick_move
        path = StarMapper.new(@board, 10).path
        first = path[-1]
        second = path[-2]

        return :up    if first[1] < second[1]
        return :down  if first[1] > second[1]
        return :left  if first[0] > second[0]
        return :right if first[0] < second[0]

        raise "FOO"
      end
    end

  end
end

