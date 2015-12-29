require 'colorize'

CHOICES = {"r" => "Rock", "p" => "Paper", "s" => "Scissors"}

def format(line)
  puts "=> #{line}"
end

def display_choices(player, computer)
  choices = {'You' => player, 'Computer' => computer}

  choices.each do |player, choice|
    if choice == 'r'
      puts "#{player} chose Rock."
    elsif choice == 'p'
      puts "#{player} chose Paper."
    elsif choice == 's'
      puts "#{player} chose Scissors."
    end
  end
end

def winning_result(choice)
  if choice == 'r'
    puts "Rock smashes Scissors!"
  elsif choice == 'p'
    puts "Paper smothers Rock!"
  elsif choice == 's'
    puts "Scissors shreds Paper!"
  end
end

loop do
  system "clear"

  puts "Welcome to Rock, Paper, Scissors!\n\n"

  begin
    format "Pick one: (R / P / S)"
    player_choice = gets.chomp.downcase
  end until CHOICES.keys.include?(player_choice)

  computer_choice = CHOICES.keys.sample

  display_choices(player_choice, computer_choice)

  if player_choice == computer_choice 
    puts "It's a tie!".colorize(:yellow)
  elsif (player_choice == 'r' && computer_choice == 's') ||
        (player_choice == 'p' && computer_choice == 'r') ||
        (player_choice == 's' && computer_choice == 'p')
    winning_result(player_choice)
    puts "Player wins!".colorize(:green)
  else
    winning_result(computer_choice) 
    puts "Computer wins!".colorize(:red)
  end

  format "Another round? (Y/N)"
  break if gets.chomp.downcase != 'y'

end