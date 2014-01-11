require 'dealer'
require 'player'

describe Dealer do
  subject(:dealer) { Dealer.new }

  it "calls super with a default name/empty bankroll" do
    dealer.name.should == "dealer"
    dealer.bankroll.should == 0
  end

  it { should be_a(Player) }

  it "should not place bets" do
    expect do
      dealer.place_bet(dealer, 100)
    end.to raise_error("Dealer doesn't bet")
  end

  describe "#play_hand" do
    let(:dealer_hand) { double("hand") }
    let(:deck) { double("deck") }

    before do
      dealer.hand = dealer_hand
    end

    it "should not hit on seventeen" do
      dealer_hand.stub(
        :busted? => false,
        :points => 17)
      dealer_hand.should_not_receive(:hit)

      dealer.play_hand(deck)
    end

    it "should hit until seventeen acheived" do
      dealer_hand.stub(:busted? => false)

      # need to use a block to give points, because we'll hit hand and
      # points will change
      points = 12
      dealer_hand.stub(:points) do
        # returns `points` defined in the outside local variable. The
        # `points` variable is said to be *captured*.
        points
      end
      dealer_hand.should_receive(:hit).with(deck).exactly(3).times do
        # changes `points` variable above, faking addition of new
        # cards.
        points += 2
      end

      dealer.play_hand(deck)
    end

    it "should stop when busted" do
      points = 16
      dealer_hand.stub(:points) { points }
      dealer_hand.stub(:busted?) { points > 21 }

      dealer_hand.should_receive(:hit).once.with(deck) do
        points = 22
      end

      dealer.play_hand(deck)
    end
  end

  context "with a player" do
    let(:player) { double("player", :hand => player_hand) }
    let(:dealer_hand) { double("dealer_hand") }
    let(:player_hand) { double("player_hand") }

    before(:each) do
      dealer.hand = dealer_hand
      player.stub(:hand => player_hand)

      dealer.take_bet(player, 100)
    end

    it "should record bets" do
      dealer.bets.should == { player => 100 }
    end

    it "should not pay losers (or ties)" do
      player_hand
        .should_receive(:beats?)
        .with(dealer_hand)
        .and_return(false)

      player.should_not_receive(:pay_winnings)
      dealer.pay_bets
    end

    it "should pay winners" do
      player_hand
        .should_receive(:beats?)
        .with(dealer_hand)
        .and_return(true)

      # wins twice the bet
      player.should_receive(:pay_winnings).with(200)

      dealer.pay_bets
    end
  end
end
