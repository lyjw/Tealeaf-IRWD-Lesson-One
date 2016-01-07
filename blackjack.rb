# Initialize Game
def initialize_deck(number_of_decks = 3)
  set = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  suits = ['♠', '♥', '♣', '♦']

  single_deck = set.product(suits)
  deck = []
  number_of_decks.times { deck.concat(single_deck) }
  deck.shuffle!
end

def initialize_hand
  hand = []
end

# Divider
def print_divider
  puts '------------------------------------------'
end

# Returns a random card from the deck
def deal_cards(deck, hand, num)
  num.times do
    card_dealt = deck.shift
    hand << card_dealt
  end
end

def hit(deck, hand)
  deal_cards(deck, hand, 1)
end

# Display Cards
def display_card(card)
  "#{card[0]} #{card[1]}"
end

def display_hand(hand)
  hand.each { |card| puts "- #{display_card(card)}" }
end

def display_dealer_upcard(hand)
  upcard = hand.first
  puts "The Dealer's upcard is: #{display_card(upcard)}"
end

# Display state of game
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

# Sum of Cards
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
  values.select { |card| card[0] == 'A' }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

# Check for Blackjack and Bust
def got_blackjack?(hand)
  sum_of_cards(hand) == 21
end

def bust?(hand)
  sum_of_cards(hand) > 21
end

def win_by_blackjack_or_bust?(hand)
  got_blackjack?(hand) || bust?(hand)
end

# Check for Winner
def check_winner(player, dealer)
  dealer_total = sum_of_cards(dealer)
  player_total = sum_of_cards(player)

  if got_blackjack?(player) || bust?(dealer) || player_total > dealer_total
    winner = "#{PLAYER_NAME}"
  elsif got_blackjack?(dealer) || bust?(player) || dealer_total > player_total
    winner = 'Dealer'
  elsif dealer_total == player_total
    winner = 'It\'s a tie.'
  end

  winner
end

def announce_winner(player, dealer, round)
  winner = check_winner(player, dealer)

  puts ''

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

# Player Turn
def player_turn(deck, hand)
  action = ''

  loop do
    # Display sum of cards
    puts "The sum of your cards is: #{sum_of_cards(hand)}"
    break if got_blackjack?(hand) || bust?(hand) || action == 'stay'

    # Hit or Stay
    puts "\nWould you like to 'Hit' or 'Stay'?"
    action = gets.chomp.downcase

    while !(['hit', 'stay'].include?(action))
      puts 'Please choose either to Hit" or "Stay":'
      action = gets.chomp.downcase
    end

    if action == 'hit'
      hit(deck, hand)
      card_dealt = hand.last
      puts "\n=> You hit and draw a #{display_card(card_dealt)}"
    end

    break if action == 'stay'
  end
end

# Dealer's Turn
def dealer_turn(deck, hand)
  puts "\nThe sum of the Dealer's cards is: #{sum_of_cards(hand)}"

  loop do
    sleep 1
    # Hit if sum of cards is less than 17
    if sum_of_cards(hand) < 17
      hit(deck, hand)
      puts "=> Dealer hits and draws a #{display_card(hand.last)}"
      puts "The sum of the Dealer's cards is: #{sum_of_cards(hand)}"
    # Stay if sum is 17 - 21
    elsif sum_of_cards(hand) < 21
      puts '=> Dealer stays.'
      break
    end
    break if got_blackjack?(hand) || bust?(hand)
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
  player_hand = initialize_hand
  dealer_hand = initialize_hand

  winner = nil

  system 'clear'
  puts "Hello, #{PLAYER_NAME}. Let Round #{round} begin.\n\n"

  deal_cards(deck, player_hand, 2)
  deal_cards(deck, dealer_hand, 2)
  display_opening_table(player_hand, dealer_hand)
  print_divider

  while winner.nil?
    player_turn(deck, player_hand)
    break if win_by_blackjack_or_bust?(player_hand)
    display_table(player_hand, dealer_hand)
    dealer_turn(deck, dealer_hand)
    break if win_by_blackjack_or_bust?(dealer_hand)
    winner = check_winner(dealer_hand, player_hand)
  end

  announce_winner(player_hand, dealer_hand, round)

  # Track number of times player wins
  if check_winner(player_hand, dealer_hand) == "#{PLAYER_NAME}"
    player_wins += 1
  end

  print_divider
  puts 'Play again? (Y/N)'
  choice = gets.chomp.downcase

  if choice == 'y'
    round += 1
    redo
  end
  break if choice != 'y'
end

puts 'Thank you for playing!'
puts "You won #{player_wins} hands out of #{round}."
