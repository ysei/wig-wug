module WigWug

  class Board
    def initialize
      @initialized = false
      @board = {}
    end

    def update distance, matrix
      validate_distance_parameter(distance)
      validate_matrix_parameter(matrix)

      first_time(distance) unless initialized?
      store_board(matrix)

      @destinations &= possible_destinations(distance)
    end

    def initialized?
      @initialized
    end

    def position
      [ @dx, @dy ]
    end

    def destinations
      @destinations
    end

    def destination
      case @destinations.size
      when 0
        raise
      when 1
        @destinations[0]
      else
        nil
      end
    end

    def [] coordinates
      @board[coordinates]
    end

    def move direction
      case direction
      when :up
        @dy += 1
      when :down
        @dy -= 1
      when :left
        @dx -= 1
      when :right
        @dx += 1
      else
        raise
      end
    end

    def look direction
      delta_x, delta_y = deltas(direction)
      @board[ [position[0] + delta_x, position[1] + delta_y] ]
    end

  private

    def first_time distance
      raise if initialized?

      @initialized = true

      @dx, @dy = 0, 0

      @destinations = possible_destinations(distance)
    end

    def possible_destinations distance
      [
        [ position[0] + distance[0], position[1] + distance[1] ],
        [ position[0] - distance[0], position[1] + distance[1] ],
        [ position[0] - distance[0], position[1] - distance[1] ],
        [ position[0] + distance[0], position[1] - distance[1] ]
      ].uniq
    end

    def validate_distance_parameter distance
      raise unless distance.is_a?(Array)
      raise unless distance.size == 2
      raise unless distance[0].is_a?(Integer)
      raise unless distance[1].is_a?(Integer)

      raise if distance == [0, 0]

      raise if distance.sort[0] < 0
    end

    def validate_matrix_parameter matrix
      raise unless matrix.is_a?(Array)
      raise unless matrix.size == 3

      raise unless matrix[0].size == 3
      raise unless matrix[1].size == 3
      raise unless matrix[2].size == 3

      matrix.flatten.each{|e|
        raise unless e.is_a?(String)
        raise unless e.size == 1
        raise unless %w{ E F G O P R }.include?(e)
      }

      raise unless matrix.flatten.select{|e| e == 'P'}.size == 1
      raise unless matrix.flatten.select{|e| e == 'R'}.size <= 1

      raise unless matrix[1][1] == 'P'
      raise unless matrix[1][1] != 'R'
    end

    def store_board matrix
      @board[ [position[0] - 1, position[1] + 1] ] = matrix[0][0]
      @board[ [position[0] - 0, position[1] + 1] ] = matrix[0][1]
      @board[ [position[0] + 1, position[1] + 1] ] = matrix[0][2]
      @board[ [position[0] - 1, position[1] - 0] ] = matrix[1][0]
      @board[ [position[0] - 0, position[1] - 0] ] = matrix[1][1]
      @board[ [position[0] + 1, position[1] - 0] ] = matrix[1][2]
      @board[ [position[0] - 1, position[1] - 1] ] = matrix[2][0]
      @board[ [position[0] - 0, position[1] - 1] ] = matrix[2][1]
      @board[ [position[0] + 1, position[1] - 1] ] = matrix[2][2]
    end

    def deltas direction
      case direction
      when :up
        [0, 1]
      when :upright
        [1, 1]
      when :right
        [1, 0]
      when :downright
        [1, -1]
      when :down
        [0, -1]
      when :downleft
        [-1, -1]
      when :left
        [-1, 0]
      when :upleft
        [-1, 1]
      else
        raise
      end
    end
  end

end

