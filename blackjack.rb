require 'pry'
require 'colorize'

# Pseudo Code
# ----------------------------------------
# Player is dealt two cards
# Dealer is dealt two cards
# Player choose to "hit" or "stay"

# Player's Turn - 
# if hit - Player is dealt one card
  # Check the sum of player's cards
    # if greater - bust
    # if 21 - win
    # if less than 21 - player can choose to hit (loop) or stay (break)
# end

# Dealer's Turn - 
# if stay - it is Dealer's turn
  # Check the sum of dealer's cards
    # if less than 17 - hit
    # if 21 - win
    # if hit - dealer is dealt one card
    # if stay - break
# end

# If neither the player or dealer won
# Reveal cards and compare the sum of the two hands
# Higher value wins

# Play again?
# ----------------------------------------

# Initialize Game
def initialize_deck(number_of_decks)
  set = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  suits = ['♠', '♥', '♣', '♦']
  d = {}
  number_of_decks.times do 
    set.each do |card|
      suits.each do |suit|
        card_with_suit = "#{card} #{suit}"
        if card.to_i != 0
          d[card_with_suit] = { value: card.to_i }
        elsif card == "J" || card == "Q" || card == "K"
          d[card_with_suit] = { value: 10 }
        elsif card == "A"
          d[card_with_suit] = { value: 11, alt_value: 1 } 
        end
      end
    end
  end
  d
end

def initialize_hand
  hand = {}
end

# Divider
def print_divider
  puts "------------------------------------------"
end

# Returns a random card from the deck
def random_card(deck)
  card = deck.keys.sample
  value = deck.fetch(card)
  deck.delete(card)

  card_dealt = [card, value]
  card_dealt
end

def deal_cards(deck, hand, num)
  num.times do 
    card_dealt = random_card(deck)
    hand[card_dealt[0]] = card_dealt[1]
  end
end

def hit(deck, hand)
  deal_cards(deck, hand, 1)
end

# Display Cards
def display_cards(hand)
  hand.each { |card, _| puts "- #{card}" }
end

def display_dealer_upcard(hand)
  puts "The Dealer's upcard is: #{hand.keys.first}"
end

# Change Ace Value
def ace_cards_held(hand)
  ace_cards = nil

  hand.keys.each do |card|
    if card.include?("A")
      ace_cards = []
      ace_cards << card
    end
  end
  ace_cards
end

def should_change_ace_value?(hand)
  bust?(hand) && ace_cards_held(hand)
end

def set_ace_value_to_one(hand)
  default_ace_value = { value: 11, alt_value: 1 }
  ace_cards = ace_cards_held(hand)

  ace_cards.each do |ace|
    hand[ace] = { value: 1, alt_value: 11 }
  end
end

# Sum of Cards
def sum_of_cards(hand)
  sum = 0

  hand.each do |card, values|
    sum += values[:value]
  end
  sum
end

# Check for Blackjack and Bust
def got_blackjack?(hand)
  sum_of_cards(hand) == 21
end

def announce_blackjack(player, dealer)
  if got_blackjack?(player)
    puts "\n#{PLAYER_NAME.upcase} GOT BLACKJACK!"
  elsif got_blackjack?(dealer)
    puts "\nDEALER GOT BLACKJACK."
  end
end

def bust?(hand)
  sum_of_cards(hand) > 21
end

def announce_bust(player, dealer)
  if bust?(player)
    puts "\nOH NO! #{PLAYER_NAME.upcase} BUST."
  elsif bust?(dealer)
    puts "\nDEALER BUST."
  end
end

def win_by_blackjack_or_bust?(player, dealer)
  got_blackjack?(dealer) || bust?(player) || got_blackjack?(player) || bust?(dealer)
end

# Check for Winner
def check_winner(player, dealer)
  dealer_total = sum_of_cards(dealer)
  player_total = sum_of_cards(player)

  # Blackjack or Bust
  if win_by_blackjack_or_bust?(player, dealer)
    if got_blackjack?(player) || bust?(dealer)
      winner = "#{PLAYER_NAME}"
    elsif got_blackjack?(dealer) || bust?(player)
      winner = 'Dealer'
    end
  # No Blackjack and No Bust
  elsif dealer_total > player_total
    winner = 'Dealer'
  elsif player_total > dealer_total
    winner = "#{PLAYER_NAME}"
  elsif dealer_total == player_total
    winner = 'It\'s a tie.'
  end
  winner
end

def announce_winner(player, dealer)
  winner = check_winner(player, dealer)

  if got_blackjack?(player) || got_blackjack?(dealer) || bust?(player) || bust?(dealer)
    puts "\nWinner: #{winner}"
  else
    puts "#{PLAYER_NAME}'s hand:"
    display_cards(player)
    puts "The sum of #{PLAYER_NAME}'s hand is #{sum_of_cards(player)}.\n\n"
    puts "Dealer's hand:"
    display_cards(dealer)
    puts "The sum of the dealer's hand is #{sum_of_cards(dealer)}.\n\n"
    puts "Winner: #{winner}"
  end

  print_divider
end

# Player Turn
def player_turn(deck, hand)
  action = ''

  puts "| #{PLAYER_NAME}'s Turn |\n\n"

  loop do 
    # Display cards in hand 
    puts "#{PLAYER_NAME}'s hand:"
    display_cards(hand)

    if should_change_ace_value?(hand)
      set_ace_value_to_one(hand)
    end

    # Display sum of cards
    puts "\nThe sum of your cards is: #{sum_of_cards(hand)}"
    break if got_blackjack?(hand) || bust?(hand) || action == 'stay'

    # Hit or Stay
    puts 'Would you like to "Hit" or "Stay"?'

    loop do
      action = gets.chomp.downcase

      if action == 'hit' || action == 'stay'
        break
      else
        puts 'Please choose either to "Hit" or "Stay":'
      end
    end 

    hit(deck, hand) if action == 'hit'
    print_divider
    break if action == 'stay'
  end
end

# Dealer's Turn
def dealer_turn(deck, hand)
  action = ''

  puts "| Dealer's Turn |\n\n"

  loop do 
    puts "Dealer's hand:"
    display_cards(hand)

    if should_change_ace_value?(hand)
      set_ace_value_to_one(hand)
    end

    sleep 1
    # Hit if sum of cards is less than 17
    if sum_of_cards(hand) < 17
      hit(deck, hand)
      puts 'Dealer hits.'
    # Stay if sum is 17 - 21
    elsif sum_of_cards(hand) < 21
      puts 'Dealer stays.'
      break
    end
    break if got_blackjack?(hand) || bust?(hand)
  end

  print_divider
end

# Game Rundown
system 'clear'

number_of_decks = 3
deck = initialize_deck(number_of_decks)
round = 1
player_wins = 0

puts 'Welcome to the Blackjack table.'
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
  display_dealer_upcard(dealer_hand)
  print_divider

  begin
    player_turn(deck, player_hand)
    break if got_blackjack?(player_hand) || bust?(player_hand)
    dealer_turn(deck, dealer_hand)
    break if got_blackjack?(player_hand) || bust?(player_hand)
    winner = check_winner(dealer_hand, player_hand)
  end until winner != nil

  announce_blackjack(player_hand, dealer_hand)
  announce_bust(player_hand, dealer_hand)
  announce_winner(player_hand, dealer_hand)

  # Track number of times player wins
  if check_winner(player_hand, dealer_hand) == "#{PLAYER_NAME}"
    player_wins += 1
  end

  puts "Play again? (Y/N)"
  choice = gets.chomp.downcase

  if choice == 'y'
    round += 1
    redo
  end
  break if choice != 'y'
end 

print_divider
puts "Thank you for playing!"
puts "You won #{player_wins} hands out of #{round}."