require 'pry'
require 'colorize'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

# Initializes hashes to track the state of the board
def initialize_board
  b = {}
  (1..9).each { |position| b[position] = ' ' }
  b
end

def initialize_reference_board
  r = {}
  (1..9).each { |position| r[position] = "#{position}" }
  r
end

# Draws the gameboard
def draw_board(board, reference_board)
  system 'clear'
  puts "\nWelcome to Tic-Tac-Toe:"
  puts "\n"
  puts "                Open Squares\n\n"
  puts " #{board[1]} | #{board[2]} | #{board[3]}       #{reference_board[1]} | #{reference_board[2]} | #{reference_board[3]}  "
  puts "-----------     -----------"
  puts " #{board[4]} | #{board[5]} | #{board[6]}       #{reference_board[4]} | #{reference_board[5]} | #{reference_board[6]}  "
  puts "-----------     -----------"
  puts " #{board[7]} | #{board[8]} | #{board[9]}       #{reference_board[7]} | #{reference_board[8]} | #{reference_board[9]}  "
  puts "\n"
end

# Checks for open squares on the board
def empty_squares?(board)
  board.select { |square, value| value == ' ' }.keys
end

# Methods to determine the best move
def two_in_a_row(winning_line, marker)
  if winning_line.values.count(marker) == 2
    winning_line.select { |square, value| value == ' ' }.keys.first
  else
    false
  end
end

def best_move(board, marker)
  WINNING_LINES.each do |line|
    sub_hash = board.select { |key| line.include? key }
    best_position = two_in_a_row(sub_hash, marker)

    return best_position if best_position
  end
  nil  
end

# On request, provides the player with a hint for their next pick
def tip(board, reference_board)
  label_hint = "Hint:".colorize(:yellow)

  if best_move(board, 'X')
    hint = best_move(board, 'X')
    draw_board(board, reference_board)
    puts "#{label_hint} Want to win? Pick square #{hint}."
  elsif best_move(board, 'O')
    hint = best_move(board, 'O')
    draw_board(board, reference_board)
    puts "#{label_hint} Want to block the computer? Pick square #{hint}."
  end
end

# Methods to check for and announce the winner
def check_winner(board)
  WINNING_LINES.each do |line|
    return "Player" if board.values_at(*line).count('X') == 3
    return "Computer" if board.values_at(*line).count('O') == 3
  end
  nil
end

def line_winner_won_with(board)
  WINNING_LINES.each do |line|
    squares = board.values_at(*line)
    if squares.count('X') == 3 || squares.count('O') == 3
      return line
    end
  end
end

def announce_winner(board, reference_board)
  system "clear"

  highlighted_winning_line = {}
  highlighted_x = 'X'.colorize(:green)
  highlighted_o = 'O'.colorize(:red)
  winner = check_winner(board)

  if winner == "Player"
    line_winner_won_with(board).each do |square|
      highlighted_winning_line[square] = highlighted_x
    end
  else
    line_winner_won_with(board).each do |square|
      highlighted_winning_line[square] = highlighted_o
    end
  end

  board.merge!(highlighted_winning_line)
  draw_board(board, reference_board)

  if winner == "Player"
    puts "You won!".colorize(:green)
  else
    puts "Computer won!".colorize(:red)
  end
end

# Player Turn Helper Methods
def pick_a_square(board)
  position = ''

  loop do
    position = gets.chomp.to_i
    puts "Please choose an open square."
    break if empty_squares?(board).include?(position)
  end 

  position
end

def pick_with_hint(board, reference_board)
  position = ''

  loop do 
    position = gets.chomp

    if position == 'hint'
      tip(board, reference_board)
    else
      position = position.to_i
    end
    puts "Please choose an open square."
    break if empty_squares?(board).include?(position)
  end

  position
end

# Determine Player/Computer picks
def player_picks_square(board, reference_board)
  position = ''

  if best_move(board, 'X') || best_move(board, 'O')
    puts "Pick a Square (Type 'hint' if you need some help):"
    position = pick_with_hint(board, reference_board)
  else
    puts "Pick a Square:"
    position = pick_a_square(board)
  end

  board[position] = 'X' 
  reference_board[position] = ' '

  draw_board(board, reference_board)
end

def computer_picks_square(board, reference_board)
  puts "Computer is choosing a square..."
  sleep 0.8

  # Play to win
  if best_move(board, 'O')
    position = best_move(board, 'O')
  # Block the player from winning
  elsif best_move(board, 'X') != nil
    position = best_move(board, 'X')
  else
    position = empty_squares?(board).sample
  end

  board[position] = 'O'
  reference_board[position] = ' '

  draw_board(board, reference_board)
end

# Gameplay
loop do
  board = initialize_board
  reference_board = initialize_reference_board
  draw_board(board, reference_board)

  begin
    player_picks_square(board, reference_board)
    break if check_winner(board)
    computer_picks_square(board, reference_board)
    break if check_winner(board)
  end until empty_squares?(board).empty?

  if check_winner(board)
    announce_winner(board, reference_board)
  else
    puts "It's a tie.".colorize(:yellow)
  end

  puts "\nAnother round? (Y/N)"
  break if gets.chomp.downcase != 'y'

end