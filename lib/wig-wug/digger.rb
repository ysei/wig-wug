require File.join(File.dirname(__FILE__), 'board')

module WigWug

  class Digger
    attr_reader :name

    def initialize name = nil
      @board ||= Board.new
      @name = name || self.class.to_s
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

