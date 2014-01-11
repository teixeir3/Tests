require 'card'
require 'hand'

describe Hand do
  describe "::deal_from" do
    it "deals a hand of two cards" do
      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three)
      ]

      deck = double("deck")
      deck.should_receive(:take).with(2).and_return(deck_cards)

      hand = Hand.deal_from(deck)

      hand.cards.should =~ deck_cards
    end
  end

  describe "#points" do
    it "adds up normal cards" do
      hand = Hand.new([
          Card.new(:spades, :deuce),
          Card.new(:spades, :four)
        ])

      hand.points.should == 6
    end

    it "counts an ace as 11 if it can" do
      hand = Hand.new([
          Card.new(:spades, :ten),
          Card.new(:spades, :ace)
        ])

      hand.points.should == 21
    end

    it "counts some aces as 1 and others as 11" do
      hand = Hand.new([
          Card.new(:spades, :ace),
          Card.new(:hearts, :ace)
        ])

      hand.points.should == 12
    end
  end

  describe "#busted?" do
    it "is busted if points > 21" do
      hand = Hand.new([])
      hand.stub(:points => 22)

      hand.should be_busted
    end

    it "is not busted if points <= 21" do
      hand = Hand.new([])
      hand.stub(:points => 21)

      hand.should_not be_busted
    end
  end

  describe "#hit" do
    it "draws a card from deck" do
      deck = double("deck")
      card = double("card")
      deck.should_receive(:take).with(1).and_return([card])

      hand = Hand.new([])
      hand.hit(deck)

      hand.cards.should include(card)
    end

    it "doesn't hit if busted" do
      deck = double("deck")
      deck.should_not_receive(:take)

      hand = Hand.new([])
      hand.should_receive(:busted?).and_return(true)

      expect do
        hand.hit(deck)
      end.to raise_error("already busted")
    end
  end

  describe "#beats?" do
    it "returns true if other hand has fewer points" do
      hand1 = Hand.new([
          Card.new(:spades, :ace),
          Card.new(:spades, :ten)
        ])
      hand2 = Hand.new([
          Card.new(:hearts, :ace),
          Card.new(:hearts, :nine)
        ])

      hand1.beats?(hand2).should be_true
      hand2.beats?(hand1).should be_false
    end

    it "returns false if hands have equal points" do
      hand1 = Hand.new([
          Card.new(:spades, :ace),
          Card.new(:spades, :ten)
        ])
      hand2 = Hand.new([
          Card.new(:hearts, :ace),
          Card.new(:hearts, :ten)
        ])

      hand1.beats?(hand2).should be_false
      hand2.beats?(hand1).should be_false
    end

    it "returns false if busted" do
      hand1 = Hand.new([
          Card.new(:spades, :ten),
          Card.new(:hearts, :ten),
          Card.new(:clubs, :ten)
        ])
      hand2 = Hand.new([
          Card.new(:hearts, :deuce),
          Card.new(:hearts, :three)
        ])

      hand1.beats?(hand2).should be_false
      hand2.beats?(hand1).should be_true
    end
  end

  describe "#return_cards" do
    let(:deck) { double("deck") }
    let(:hand) do
      Hand.new([Card.new(:spades, :deuce), Card.new(:spades, :three)])
    end

    it "returns cards to deck" do
      deck.should_receive(:return) do |cards|
        cards.count.should == 2
      end

      hand.return_cards(deck)
    end

    it "removes card from hand" do
      deck.stub(:return)

      hand.return_cards(deck)
      hand.cards.should == []
    end
  end
end
