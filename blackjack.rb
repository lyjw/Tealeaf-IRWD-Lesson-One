BLACKJACK = 21
DEALER_MIN_HAND = 17

def initialize_deck(number_of_decks = 3)
  set = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  suits = ['♠', '♥', '♣', '♦']

  single_deck = set.product(suits)
  deck = []
  number_of_decks.times { deck.concat(single_deck) }
  deck.shuffle!
end

def new_hand
  []
end

def print_divider
  puts '------------------------------------------'
end

def deal_cards(deck, hand, num)
  num.times do
    card_dealt = deck.shift
    hand << card_dealt
  end
end

def hit(deck, hand)
  deal_cards(deck, hand, 1)
end

def formatted_card_string(card)
  "#{card[0]} #{card[1]}"
end

def display_hand(hand)
  hand.each { |card| puts "- #{formatted_card_string(card)}" }
end

def display_dealer_upcard(hand)
  upcard = hand.first
  puts "The Dealer's upcard is: #{formatted_card_string(upcard)}"
end

def display_opening_table(player, dealer)
  display_dealer_upcard(dealer)
  print_divider
  puts "#{PLAYER_NAME}'s hand:"
  display_hand(player)
end

def display_table(player, dealer)
  system 'clear'

  puts "Dealer's Hand:"
  display_hand(dealer)
  print_divider
  puts "#{PLAYER_NAME}'s Hand:"
  display_hand(player)
end

def sum_of_cards(hand)
  values = hand.map { |card| card[0] }

  sum = 0
  values.each do |value|
    if value == 'A'
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.count { |card| card[0] == 'A' }.times do
    sum -= 10 if sum > BLACKJACK
  end

  sum
end

def got_blackjack?(hand)
  sum_of_cards(hand) == BLACKJACK
end

def bust?(hand)
  sum_of_cards(hand) > BLACKJACK
end

def win_by_blackjack_or_bust?(hand)
  got_blackjack?(hand) || bust?(hand)
end

def check_winner(player, dealer)
  player_total = sum_of_cards(player)
  dealer_total = sum_of_cards(dealer)

  if win_by_blackjack_or_bust?(player) || win_by_blackjack_or_bust?(dealer)
    if got_blackjack?(player) || bust?(dealer)
      winner = "#{PLAYER_NAME}"
    elsif got_blackjack?(dealer) || bust?(player)
      winner = 'Dealer'
    end
  elsif player_total > dealer_total
    winner = "#{PLAYER_NAME}"
  elsif dealer_total > player_total
    winner = 'Dealer'
  elsif dealer_total == player_total
    winner = 'It\'s a tie.'
  end

  winner
end

def announce_winner(player, dealer, round)
  winner = check_winner(player, dealer)

  puts

  if got_blackjack?(player)
    puts 'Congratulations, you got blackjack!'
  elsif bust?(player)
    puts 'Oh no, you bust.'
  elsif got_blackjack?(dealer)
    puts 'Sorry, Dealer got blackjack!'
  elsif bust?(dealer)
    puts 'Dealer bust.'
  else
    puts "The sum of #{PLAYER_NAME}'s hand is #{sum_of_cards(player)}."
    puts "The sum of the Dealer's hand is #{sum_of_cards(dealer)}."
  end

  puts "\nWinner of Round #{round}: #{winner}"
end

def player_turn(deck, hand)
  action = ''

  loop do
    puts "The sum of your cards is: #{sum_of_cards(hand)}"
    break if win_by_blackjack_or_bust?(hand)

    puts "\nWould you like to 'Hit' or 'Stay'?"
    action = gets.chomp.downcase

    until ['hit', 'stay'].include?(action)
      puts 'Please choose either to Hit" or "Stay":'
      action = gets.chomp.downcase
    end

    if action == 'hit'
      hit(deck, hand)
      card_dealt = hand.last
      puts "\n=> You hit and draw a #{formatted_card_string(card_dealt)}"
    end

    break if action == 'stay'
  end
end

def dealer_turn(deck, hand)
  puts "\nThe sum of the Dealer's cards is: #{sum_of_cards(hand)}"

  loop do
    sleep 1

    if sum_of_cards(hand) < DEALER_MIN_HAND
      hit(deck, hand)
      puts "=> Dealer hits and draws a #{formatted_card_string(hand.last)}"
      puts "The sum of the Dealer's cards is: #{sum_of_cards(hand)}"
    elsif sum_of_cards(hand) < BLACKJACK
      puts '=> Dealer stays.'
      break
    end
    break if win_by_blackjack_or_bust?(hand)
  end

  print_divider
end

# Game Rundown
system 'clear'

deck = initialize_deck
round = 1
player_wins = 0

puts 'Welcome to the Blackjack table!'
puts 'What is your name?'
PLAYER_NAME = gets.chomp

loop do
  player_hand = new_hand
  dealer_hand = new_hand

  winner = nil

  system 'clear'
  puts "Hello, #{PLAYER_NAME}. Let Round #{round} begin.\n\n"

  deal_cards(deck, player_hand, 2)
  deal_cards(deck, dealer_hand, 2)
  display_opening_table(player_hand, dealer_hand)
  print_divider

  until winner
    player_turn(deck, player_hand)
    winner = check_winner(player_hand, dealer_hand)
    break if win_by_blackjack_or_bust?(player_hand)
    display_table(player_hand, dealer_hand)
    dealer_turn(deck, dealer_hand)
    winner = check_winner(player_hand, dealer_hand)
    break if win_by_blackjack_or_bust?(dealer_hand)
  end

  announce_winner(player_hand, dealer_hand, round)

  if winner == "#{PLAYER_NAME}"
    player_wins += 1
  end

  print_divider
  puts 'Play again? (Y/N)'
  choice = gets.chomp.downcase

  if choice == 'y'
    round += 1
    next
  end
  break if choice != 'y'
end

puts 'Thank you for playing!'
puts "You won #{player_wins} hands out of #{round}."
