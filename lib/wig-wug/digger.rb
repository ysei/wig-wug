module WigWug

  class Digger
    attr_reader :name

    def initialize name = self.class.to_s
      @board = Board.new
      @name = name
    end

    def move! distance, matrix
      @board.update(distance, matrix)
      move = pick_move
      @board.move(move)
      return move
    end

  private

    def pick_move
      raise "OVERRIDE_IN_DIGGER_CLASS"
    end
  end

end

