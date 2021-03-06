require 'colorize'
require_relative 'cursorable'
require_relative 'display.rb'
require_relative 'board.rb'
require_relative 'pieces/pieces.rb'
require_relative 'player.rb'


class Game
  include Cursorable
  def initialize(board = nil)
    board ||= Board.new
    @board = board
    @display = Display.new(@board)
    @player_white = HumanPlayer.new(@display, :white)
    @player_black = HumanPlayer.new(@display, :black)
    @current_player = @player_white
  end

  def run
    puts "Welcome to Chess!"
    sleep(1)

    until @board.checkmate?(@current_player.color) || @board.stalemate?(@current_player.color)
      @board.check?(@current_player.color)
      begin
        @display.render(@current_player)
        begin
          start_pos = @current_player.take_turn
          valid_piece?(start_pos)
        rescue
          puts "Pick your own piece!"
          sleep(1)
          retry
        end
        end_pos = @current_player.take_turn
        @board.move(start_pos, end_pos)
      rescue
        puts "Not a valid move!"
        sleep(1)
        retry
      end
      switch_turns
    end
    if @board.checkmate?(@current_player.color)
      switch_turns
      @display.render(@current_player)
      puts "Congrats #{@current_player.color} player! You Win!"
    end
    if @board.stalemate?(@current_player.color)
      puts "Stalemate!!!"
    end
  end

  def switch_turns
    @current_player == @player_white ? @current_player = @player_black : @current_player = @player_white
  end


  def valid_piece?(input_pos)
    raise "pick your own piece" unless @board[input_pos].color == @current_player.color
    true
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.run
end
