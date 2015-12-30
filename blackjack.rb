require 'pry'

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
# Compare the sum of the two hands
# Higher value wins

# Play again?
# ----------------------------------------

# Initialize deck
def initialize_deck
  set = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  d = {}
  set.each do |card|
    ['♠', '♥', '♣', '♦'].each do |suit|
      card_with_suit = "#{card} #{suit}"
      if card.to_i != 0
        d[card_with_suit] = { value: card.to_i, alt_value: nil }
      elsif card == "J" || card == "Q" || card == "K"
        d[card_with_suit] = { value: 10, alt_value: nil }
      elsif card == "A"
        d[card_with_suit] = { value: 11, alt_value: 1 } 
      end
    end
  end
  d
end

# Initalize Player and Dealer hands
def initialize_hand
  hand = {}
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

def display_cards(hand)
  puts "Your hand consists of the following cards:"
  hand.each { |card, _| puts "- #{card}" }
end

# Change Ace value
def ace_cards_held(hand)
  ace_cards = nil

  hand.keys.each do |card|
    if card.include?("A")
      ace_cards = []
      ace_cards << card
    end
  end
  ace_cards # ["A ", "A "]
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

def sum_of_cards(hand)
  sum = 0

  hand.each do |card, values|
    sum += values[:value]
  end
  sum
end

# Determine winner
def got_blackjack?(hand)
  sum_of_cards(hand) == 21
end

def bust?(hand)
  sum_of_cards(hand) > 21
end

def check_for_blackjack_winner(dealer, player)
  if got_blackjack?(dealer)
    winner = 'Dealer'
  elsif got_blackjack?(player)
    winner = 'You'
  else
    winner = nil
  end
  winner
end

def got_blackjack?(hand)
  sum_of_cards(hand) == 21
end

def bust?(hand)
  sum_of_cards(hand) > 21
end

def hit(deck, hand)
  deal_cards(deck, hand, 1)
end

# Player Gameplay
def player_turn(deck, hand)
  action = ''

  puts '| Player\'s Turn |'

  loop do 
    # Display cards in hand 
    display_cards(hand)

    if should_change_ace_value?(hand)
      set_ace_value_to_one(hand)
    end

    # Display sum of cards
    puts "\nThe sum of your cards is: #{sum_of_cards(hand)}"
    break if got_blackjack?(hand) || bust?(hand) || action == 'stay'

    # Hit or Stay
    puts 'Would you like to "Hit" or "Stay"?'
    action = gets.chomp.downcase

    # Hit
    if action == 'hit'
      hit(deck, hand)
    # Stay
    elsif action == 'stay'
      break
    # Input Error if Player does not choose one of the given options
    else
      begin
        puts 'Please choose either to "Hit" or "Stay:"'
        action = gets.chomp.downcase
      end until action == 'hit' && action == 'stay'
    end

  end

end

# Game Rundown
# loop do
  system 'clear'

  deck = initialize_deck
  player_hand = initialize_hand
  dealer_hand = initialize_hand
  winner = nil

  puts 'Welcome to the Blackjack table.'
  puts 'What is your name?'
  player_name = gets.chomp
  puts "Hello, #{player_name}. Let the games begin."

  deal_cards(deck, player_hand, 2)
  deal_cards(deck, dealer_hand, 2)

  begin
    player_turn(deck, player_hand)
    break
  end until got_blackjack?(player_hand) || got_blackjack?(dealer_hand) || bust?(player_hand) || bust?(dealer_hand)
# end 
