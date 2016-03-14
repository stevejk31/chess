require "colorize"
class Piece
  attr_reader :board, :color, :num_moves, :last_turn
  attr_accessor :pos_moves, :pos

  def initialize (pos, color, board)
    @pos = pos
    @board = board
    @color = color
    @pos_moves = []
    @num_moves = 0
    @last_turn = 0
  end

  def to_s
    "   ".colorize(color)
  end

  def in_bounds?(pos)
    @board.in_bounds?(pos)
  end

  def moved_piece(num_turns)
    @num_moves += 1
    @last_turn = num_turns
  end

  def moved?
    @num_moves > 0
  end

  def dup(board)
    if self.class == NilPiece
      duped_piece = NilPiece.new
    else
      duped_piece = self.class.new(@pos.dup, @color, board)
      duped_piece.pos_moves = deep_dup(@pos_moves) unless @pos.nil?
    end
    duped_piece
  end

  def deep_dup(array)
    return array if array.empty?
    dup = []
    array.each do |el|
      el.is_a?(Array) ? dup << deep_dup(el) : dup << el
    end
    dup
  end

  def put_in_check?
    @pos_moves.each do |position|
      return true if @board[position].class == King && opponent?(position)
    end
    false
  end

  def opponent?(pos)
    return false if @board[pos].class == NilPiece || @board[pos].nil?
    return true if @board[pos].color != self.color
    false
  end

end
