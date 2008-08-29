require File.join(File.dirname(__FILE__), 'astar', 'AMap')

module WigWug
  module Diggers

    class AstarDigger < Digger
      def initialize
        @astar_timeout ||= 20
        super
      end

      def pick_move
        path = find_path
        first = path[-1]
        second = path[-2]

        return :up    if first[1] < second[1]
        return :down  if first[1] > second[1]
        return :left  if first[0] > second[0]
        return :right if first[0] < second[0]

        raise "FOO"
      end

    private

      def find_path
        b = @board.instance_variable_get("@board")
        d = @board.destinations.sort_by{rand}.first

        x_offset, y_offset, x_size, y_size = calculate_bounds(b, d)

        start = [ @board.position[0] - x_offset, @board.position[1] - y_offset ]
        finish = [ d[0] - x_offset, d[1] - y_offset ]

        cmap = build_cmap b, x_offset, y_offset, x_size, y_size
        amap = ::AStar::AMap.new(cmap)

        player = amap.co_ord(start[0], start[1])
        ruby = amap.co_ord(finish[0], finish[1])
        route = amap.astar(player, ruby, @astar_timeout)
        raise "No route!" unless route
        puts amap.show_path(route) if $DEBUG

        build_path(route, start)
      end

      def build_path route, start
        path = []
        current = route
        while current.parent do
          path << current
          raise "No current!" unless current
          current = current.parent
        end
        path.map{|n| [n.x, n.y]} << start
      end

      def calculate_bounds b, d
        k = b.keys

        xs = (k.map{|z| z[0]} << d[0]).sort
        ys = (k.map{|z| z[1]} << d[1]).sort

        x_offset = xs.first - 1
        y_offset = ys.first - 1
        x_size = xs.last - xs.first + 3
        y_size = ys.last - ys.first + 3

        [ x_offset, y_offset, x_size, y_size ]
      end

      def build_cmap b, x_offset, y_offset, x_size, y_size
        cmap = Array.new(y_size){Array.new(x_size){1}}
        b.each do |k, v|
          cmap[k[1] - y_offset][k[0] - x_offset] = set_cost(k, v)
        end
        cmap
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

