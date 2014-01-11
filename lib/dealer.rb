require_relative 'player'

class Dealer < Player
  attr_reader :bets

  def initialize
    super("dealer", 0)

    @bets = {}
  end

  def place_bet(dealer, amt)
    raise "Dealer doesn't bet" if dealer == self
  end

  def play_hand(deck)
    until @hand.points >= 17
      @hand.hit(deck) unless @hand.points >= 17
    end
  end

  def take_bet(player, amt)
    @bets[player] = amt
  end

  def pay_bets
    @bets.each do |player, bet|
      player.pay_winnings(bet*2) if player.hand.beats?(@hand)
    end
  end
end
