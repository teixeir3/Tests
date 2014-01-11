require_relative 'card'

class NotEnoughCardsError < StandardError
end

# Represents a deck of playing cards.
class Deck
  # Returns an array of all 52 playing cards.

  def self.all_cards
    cards_arr = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        cards_arr << Card.new(suit, value)
      end
    end

    cards_arr
  end

  def initialize(cards = Deck.all_cards)

    @cards = cards
  end

  # Returns the number of cards in the deck.
  def count
    @cards.count
  end

  # Takes `n` cards from the top of the deck.
  def take(n)
    raise "not enough cards" if n > @cards.count
    taken_cards = []

    until taken_cards.count == n
      taken_cards << @cards.shift
    end

    taken_cards
  end

  # Returns an array of cards to the bottom of the deck.
  def return(cards)

    cards.count.times do |i|
      @cards << cards[i]
    end

    nil
  end
end
