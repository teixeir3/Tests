class Hand
  # This is called a *factory method*; it's a *class method* that
  # takes the a `Deck` and creates and returning a `Hand`
  # object. This is in contrast to the `#initialize` method that
  # expects an `Array` of cards to hold.


  def self.deal_from(deck)
    Hand.new(deck.take(2))
  end

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def points
    total_points = 0
    num_aces = 0

    @cards.each do |card|
      if card.value == :ace
        num_aces += 1
        next
      end
      total_points += card.blackjack_value
    end


    num_aces.times do
      if total_points + 11 <= 21
        total_points += 11
      else
        total_points += 1
      end
    end

    total_points
  end

  def busted?
    return true if points > 21

    false
  end

  def hit(deck)
    raise "already busted" if busted?
    new_card = deck.take(1)
    @cards << new_card[0]

    nil
  end

  def beats?(other_hand)
    return false if self.busted?
    if other_hand.busted?
      return true
    elsif self.points > other_hand.points
      return true
    elsif self.points == other_hand.points
      return false
    end
  end

  def return_cards(deck)
    returned_cards = []

    until @cards.count == 0
      returned_cards << @cards.shift
    end

    deck.return(returned_cards)

    nil
  end

  def to_s
    @cards.join(",") + " (#{points})"
  end
end
