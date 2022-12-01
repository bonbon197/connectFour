# ./lib/game.rb

require_relative 'players'
require_relative 'board'

class Game
  attr_reader :player1, :player2, :positions, :board, :current_player

  SYMBOLS = ['⚫', '⚪']

  def initialize
    @board = Board.new
  end

  def setup
    intro_message
    board.display
    @player1 = create_player(1)
    @player2 = create_player(2)
    randomize_first_turn
  end

  def intro_message
    intro = <<-MESSAGE
Now playing Connect Four, Terminal Edition.
First player to make four connections either horizontally, vertically, or diagonally wins.
CPU is dumb so it only follows Player1's moves, for now.
Make sure to enter a valid column number from 1-7.
Game automatically exits upon winner declaration.
Run connectFour.rb again to play.
MESSAGE
    puts intro
  end

  def create_player(number)
    puts "\nPlayer #{number}, enter your name. Enter the word \"CPU\" to enter AI mode"
    name = gets.chomp.capitalize
    mark = SYMBOLS[number - 1]
    if name == "Cpu"
      CPUPlayer.new(name, mark)
    else
      HumanPlayer.new(name, mark)
    end
  end

  def randomize_first_turn
    @current_player = [@player1, @player2].sample
  end

  def play_game
    setup

    until board.game_over?(current_player.mark)
      @current_player = switch_turns
      play_round
    end
    conclusion
  end

  def play_round
    prompt_player
    move = solicit_move
    board.place_token(move, current_player.mark)
    board.display
  end

  def switch_turns
    current_player == player1 ? player2 : player1
  end

  def prompt_player
    puts "\n#{current_player.name}, your turn. Please choose any row between 1-7 to drop your token:"
  end

  def solicit_move
    loop do
      if current_player.class == HumanPlayer
        move = gets.chomp.to_i 
      else
        move = current_player.random_move.to_i
      end
      return move if valid_move?(move)

      puts 'Invalid input. Please choose an empty column between 1-7.'
    end
  end

  def valid_move?(move)
    move.is_a?(Integer) && move.between?(1, 7) && board.grid[0][move - 1] == '  '
  end

  def conclusion
    puts "\n#{current_player.name} wins!" if board.game_won?(current_player.mark)
    puts 'Tie game.' if board.full?
  end
end