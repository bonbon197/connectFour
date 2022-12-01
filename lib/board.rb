# ./lib/board.rb

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7, '  ') }
  end

  def display
    puts
    puts ' ' + (1..7).to_a.join('   ')
    puts '----------------------------'
    (0..5).each { |i| puts grid[i].join('| ') }
  end

  def place_token(number, symbol)
    column = number - 1
    row = find_available_row(column)
    grid[row][column] = symbol
  end

  def game_over?(symbol)
    game_won?(symbol) || full?
  end

  def game_won?(symbol)
    horizontal_win?(symbol) || vertical_win?(symbol) || diagonal_win?(symbol)
  end

  def full?
    grid.all? do |row|
      row.all? { |slot| slot == '⚫' || slot == '⚪' }
    end
  end

  private
  
  def find_available_row(row = 5, column)
    return row if grid[row][column] != '⚫' && grid[row][column] != '⚪'
    return if row < 0

    find_available_row(row - 1, column)
  end

  def horizontal_win?(symbol, row = 0, columns = [0, 1, 2, 3])
    grid.any? do |row|
      row.each_cons(4) do |four_slots|
        return true if four_slots.all? { |slot| slot == symbol }
      end
    end
  end

  def vertical_win?(symbol, column = 0, rows = [0, 1, 2, 3])
    return false if column == 7    
    return true if rows.all? { |row| grid[row][column] == symbol }

    rows.map! { |row| row += 1 }
    
    if rows == [3, 4, 5, 6]
      vertical_win?(symbol, column + 1)
    else
      vertical_win?(symbol, column, rows)
    end
  end

  def diagonal_win?(symbol)
    diagonals = create_diagonals

    diagonals.any? do |diagonal_set|
      diagonal_set.all? do |coords|
        grid[coords[0]][coords[1]] == symbol
      end
    end
  end

  def create_diagonals
    diagonals = []

    grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        diagonals << right_diagonal([[row_idx, col_idx]])
        diagonals << left_diagonal([[row_idx, col_idx]])
      end
    end

    diagonals.reject! { |diagonal| diagonal.length < 4 }
  end

  def right_diagonal(diagonal)
    3.times do
      unless diagonal[-1][0] == 5 || diagonal[-1][1] == 6
        diagonal << [diagonal[-1][0] + 1, diagonal[-1][1] + 1]
      end
    end

    diagonal
  end

  def left_diagonal(diagonal)
    3.times do
      unless diagonal[-1][0] == 5 || diagonal[-1][1] == 0
        diagonal << [diagonal[-1][0] + 1, diagonal[-1][1] - 1]
      end
    end

    diagonal
  end
end