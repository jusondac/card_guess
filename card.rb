# Represents a single playing card
class Card
  SUITS = ['Hearts', 'Diamonds', 'Clubs', 'Spades'].freeze
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze
  SUIT_ICONS = {
    'Hearts' => '♥️',
    'Diamonds' => '♦️',
    'Clubs' => '♣️',
    'Spades' => '♠️'
  }.freeze
  
  attr_reader :rank, :suit
  
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  
  def to_s
    "#{@rank}#{SUIT_ICONS[@suit]}"
  end
  
  def detailed_string
    "#{@rank} of #{@suit} #{SUIT_ICONS[@suit]}"
  end
  
  def ==(other)
    other.is_a?(Card) && @rank == other.rank && @suit == other.suit
  end
  
  def same_rank?(other)
    @rank == other.rank
  end
end