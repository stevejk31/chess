require 'colorize'
require_relative 'cursorable'
require_relative 'board.rb'
require_relative 'pieces/pieces.rb'

class Display
  include Cursorable
  attr_reader :board

  def initialize(board = nil)
    board ||= Board.new
    @board = board
    @cursor_pos = [0,0]
  end

  def build_grid
    output_board = [[" \\ ", " a ", " b ", " c ", " d ", " e ", " f ", " g ", " h "]]
    @board.grid.map.with_index do |row, i|
      output_board.push(build_row(row, i).unshift(" #{8-i} "))
      build_row(row, i)
    end
  output_board
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :green
    elsif (i + j).odd?
      bg = :magenta
    else
      bg = :light_blue
    end
    { background: bg } #, color: :black
  end

  def render(player)
    system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    puts "#{player.to_s}'s turn"
    puts "You're in check" if @board.board_status == :check
    build_grid.each { |row| puts row.join }
  end

end
d = Display.new
