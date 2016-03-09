class Board
  attr_reader :grid, :board_status

  def initialize(pop = true)
    @grid = Array.new(8) {Array.new(8) {NilPiece.new}}
    @board_status = :normal
    populate if pop
  end

  def move(start_pos, end_pos)
    raise "There is no piece to move" if self[start_pos].nil?
    raise "That is not a valid move" unless valid_move?(start_pos, end_pos)
    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
    self[end_pos].pos = end_pos
    kill(start_pos)
  end

  def kill(pos)
    self[pos] = NilPiece.new if self[pos].class != NilPiece
  end

  def valid_move?(start_pos, end_pos)
    piece = self[start_pos]
    piece.moves
    if piece.pos_moves.include?(end_pos)
      !in_check?(start_pos, end_pos)
    else
      false
    end
  end

  def in_check?(start_pos, end_pos)
    duped_board = self.dup
    current_piece = duped_board[start_pos]
    duped_board.move!(start_pos, end_pos)
    duped_board.check?(current_piece.color)
  end

  def check?(color)
    @grid.flatten.each do |square|
      if !square.is_a?(NilPiece) && square.color != color
        square.moves
        if square.put_in_check?
          @board_status = :check
          return true
        end
      end
    end
    @board_status = :normal
    false
  end

  def checkmate?(color)
    every_pieces_moves = []
    @grid.flatten.each do |square|
      if square.color == color
        square.moves
        square.pos_moves.each do |move|
          every_pieces_moves << move unless in_check?(square.pos, move)
          return false unless in_check?(square.pos, move)
        end
      end
    end
    @board_status = :checkmate
    true
  end

  def stalemate?(color)
    every_pieces_moves = []
    @grid.flatten.each do |square|
      if square.color == color
        square.moves
        square.pos_moves.each do |move|
          every_pieces_moves << move unless in_check?(square.pos, move)
          return false unless in_check?(square.pos, move)
        end
      end
    end
    true
  end

  def dup
    duped_board = Board.new(false)
    (0..7).each do |row|
      (0..7).each do |col|
        duped_board[[row,col]] = self[[row,col]].dup(duped_board)
      end
    end
    duped_board
  end

  def in_bounds?(pos)
    row, col = pos
    row.between?(0, 7) && col.between?(0, 7)
  end

  def populate

    @grid[1].each_with_index do |square, col|
      self[[1,col]] = Pawn.new([1, col], :black, self)
    end
    @grid[6].each_with_index do |square, col|
      self[[6,col]] = Pawn.new([6, col], :white, self)
    end

    self[[0,0]] = Rook.new([0,0], :black, self)
    self[[0,7]] = Rook.new([0,7], :black, self)
    self[[7,0]] = Rook.new([7,0], :white, self)
    self[[7,7]] = Rook.new([7,7], :white, self)

    self[[0,1]] = Knight.new([0,1], :black, self)
    self[[0,6]] = Knight.new([0,6], :black, self)
    self[[7,1]] = Knight.new([0,1], :white, self)
    self[[7,6]] = Knight.new([7,6], :white, self)

    self[[0,2]] = Bishop.new([0,2], :black, self)
    self[[0,5]] = Bishop.new([0,5], :black, self)
    self[[7,2]] = Bishop.new([7,2], :white, self)
    self[[7,5]] = Bishop.new([7,5], :white, self)

    self[[0,3]] = Queen.new([0,3], :black, self)
    self[[7,3]] = Queen.new([7,3], :white, self)

    self[[0,4]] = King.new([0,4], :black, self)
    self[[7,4]] = King.new([7,4], :white, self)

  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

end
