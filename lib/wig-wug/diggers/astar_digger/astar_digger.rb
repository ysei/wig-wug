require File.join(File.dirname(__FILE__), 'astar', 'AMap')

module WigWug
  module Diggers

    class AstarDigger < Digger
      def pick_move
        path = find_path(20)
        first = path[-1]
        second = path[-2]

        return :up    if first[1] < second[1]
        return :down  if first[1] > second[1]
        return :left  if first[0] > second[0]
        return :right if first[0] < second[0]

        raise "FOO"
      end

    private

      def find_path(timeout = 30)
        b = @board.instance_variable_get("@board")
        k = b.keys
        d = @board.destinations.sort_by{rand}.first
        xs = (k.map{|z| z[0]} << d[0]).sort
        ys = (k.map{|z| z[1]} << d[1]).sort
        x_offset = xs.first - 1
        y_offset = ys.first - 1
        x_size = xs.last - xs.first + 3
        y_size = ys.last - ys.first + 3
        cmap = Array.new(y_size){Array.new(x_size){1}}
        b.each do |k, v|
          cmap[k[1] - y_offset][k[0] - x_offset] = set_cost(k, v)
        end
        start = [ @board.position[0] - x_offset, @board.position[1] - y_offset ]
        finish = [ d[0] - x_offset, d[1] - y_offset ]
        amap = ::AStar::AMap.new(cmap)
        player = amap.co_ord(start[0], start[1])
        ruby = amap.co_ord(finish[0], finish[1])
        route = amap.astar(player, ruby, timeout)
        raise "No route!" unless route
        path = []
        current = route
        while current.parent do
          path << current
          raise "No current!" unless current
          current = current.parent
        end
        puts amap.show_path(route) if $DEBUG
        path.map{|n| [n.x, n.y]} << start
      end

      def set_cost k, v
        case v
        when 'F'
          2
        when 'E'
          0
        when 'G'
          0
        else
          1
        end
      end
    end

  end
end

