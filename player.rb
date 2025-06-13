# Represents a player in the game
class Player
  attr_reader :name, :hand, :books
  attr_accessor :score
  
  def initialize(name, is_bot = false)
    @name = name
    @hand = []
    @books = []
    @score = 0
    @is_bot = is_bot
    # Bot intelligence: track what cards other players have received/given
    @known_cards = {} # player_name => {rank => [suits]}
    @given_cards_history = {} # player_name => {rank => [suits]} - cards they gave away
  end
  
  def add_card(card)
    @hand << card
    check_for_books
  end
  
  def add_cards(cards)
    @hand.concat(cards)
    check_for_books
  end
  
  def has_rank?(rank)
    @hand.any? { |card| card.rank == rank }
  end
  
  def give_cards_of_rank(rank)
    cards_to_give = @hand.select { |card| card.rank == rank }
    @hand.reject! { |card| card.rank == rank }
    cards_to_give
  end
  
  def hand_size
    @hand.size
  end
  
  def display_hand
    @hand.map(&:to_s).join(' ')
  end
  
  def display_detailed_hand
    @hand.map(&:detailed_string).join(', ')
  end
  
  def bot?
    @is_bot
  end

  # Bot intelligence methods
  def observe_card_exchange(giver_name, receiver_name, rank, suit)
    return unless bot? # Only bots track this information
    
    # Track that the receiver got this card
    @known_cards[receiver_name] ||= {}
    @known_cards[receiver_name][rank] ||= []
    @known_cards[receiver_name][rank] << suit unless @known_cards[receiver_name][rank].include?(suit)
    
    # Track that the giver gave away this card (they don't have it anymore)
    @given_cards_history[giver_name] ||= {}
    @given_cards_history[giver_name][rank] ||= []
    @given_cards_history[giver_name][rank] << suit unless @given_cards_history[giver_name][rank].include?(suit)
    
    # Remove from known cards of giver (they don't have it anymore)
    if @known_cards[giver_name] && @known_cards[giver_name][rank]
      @known_cards[giver_name][rank].delete(suit)
      @known_cards[giver_name].delete(rank) if @known_cards[giver_name][rank].empty?
    end
  end

  def likely_has_card?(player_name, rank, suit)
    return false unless bot?
    
    # Check if we know they have this specific card
    return true if @known_cards[player_name] && 
                   @known_cards[player_name][rank] && 
                   @known_cards[player_name][rank].include?(suit)
    
    # Check if they gave away this card (they definitely don't have it)
    return false if @given_cards_history[player_name] && 
                    @given_cards_history[player_name][rank] && 
                    @given_cards_history[player_name][rank].include?(suit)
    
    false
  end

  def likely_has_multiple_cards_of_rank?(player_name, rank)
    return false unless bot?
    
    # Check if we know they received cards of this rank
    known_suits = @known_cards[player_name] && @known_cards[player_name][rank] ? 
                  @known_cards[player_name][rank].size : 0
    
    # If they received cards of this rank, they likely have more cards of that rank
    # (since people usually keep similar ranks together)
    known_suits > 0
  end

  def get_best_target_for_rank_and_suit(rank, suit, other_players)
    return other_players.sample unless bot?
    
    # Priority 1: Players we know have this specific card
    definite_targets = other_players.select { |p| likely_has_card?(p.name, rank, suit) }
    return definite_targets.sample unless definite_targets.empty?
    
    # Priority 2: Players who likely have multiple cards of this rank
    # (if they received one card of this rank, they might have others)
    likely_multiple_targets = other_players.select do |p| 
      likely_has_multiple_cards_of_rank?(p.name, rank) &&
      !(@given_cards_history[p.name] && 
        @given_cards_history[p.name][rank] && 
        @given_cards_history[p.name][rank].include?(suit))
    end
    return likely_multiple_targets.sample unless likely_multiple_targets.empty?
    
    # Priority 3: Players who haven't given away this card
    possible_targets = other_players.reject do |p| 
      @given_cards_history[p.name] && 
      @given_cards_history[p.name][rank] && 
      @given_cards_history[p.name][rank].include?(suit)
    end
    
    possible_targets.empty? ? other_players.sample : possible_targets.sample
  end

  def get_intelligent_targets(rank, suit, other_players)
    return other_players unless bot?
    
    # Prioritize players we know have the card
    priority_targets = other_players.select { |p| likely_has_card?(p.name, rank, suit) }
    return priority_targets unless priority_targets.empty?
    
    # Then consider players who might have it (haven't given it away)
    possible_targets = other_players.reject do |p| 
      @given_cards_history[p.name] && 
      @given_cards_history[p.name][rank] && 
      @given_cards_history[p.name][rank].include?(suit)
    end
    
    possible_targets.empty? ? other_players : possible_targets
  end
  
  def choose_rank_to_ask(prompt = nil, other_players = nil)
    if bot?
      # Bot uses advanced intelligence to choose ranks strategically
      available_ranks = @hand.map(&:rank).uniq
      
      # Filter to only ranks that other players might have
      if other_players
        other_player_ranks = other_players.flat_map { |p| p.hand.map(&:rank) }.uniq
        available_ranks = available_ranks & other_player_ranks
      end
      
      return available_ranks.sample if available_ranks.empty?
      
      # Advanced priority: ranks where we know someone has multiple cards of that rank
      # and we have cards of that rank (high chance of success + book completion)
      high_priority_ranks = available_ranks.select do |rank|
        my_suits_for_rank = @hand.select { |card| card.rank == rank }.map(&:suit)
        
        # Check if any player likely has multiple cards of this rank
        other_players.any? do |player|
          likely_has_multiple_cards_of_rank?(player.name, rank) && 
          my_suits_for_rank.size >= 2 # We have multiple cards too
        end
      end
      
      # Medium priority: ranks where we know someone has cards we need
      medium_priority_ranks = available_ranks.select do |rank|
        my_suits_for_rank = @hand.select { |card| card.rank == rank }.map(&:suit)
        needed_suits = Card::SUITS - my_suits_for_rank
        
        needed_suits.any? do |suit|
          other_players.any? { |p| likely_has_card?(p.name, rank, suit) }
        end
      end
      
      # Return highest priority available
      return high_priority_ranks.sample unless high_priority_ranks.empty?
      return medium_priority_ranks.sample unless medium_priority_ranks.empty?
      available_ranks.sample
    else
      # Human player input using TTY::Prompt
      puts "\n🃏 Your hand: #{display_hand}"
      my_ranks = @hand.map(&:rank).uniq
      
      # Filter to only ranks that other players actually have
      if other_players
        other_player_ranks = other_players.flat_map { |p| p.hand.map(&:rank) }.uniq
        available_ranks = my_ranks & other_player_ranks
        
        if available_ranks.empty?
          puts "❌ No other players have ranks you need! Turn skipped."
          return nil
        end
      else
        available_ranks = my_ranks
        puts "📋 You have these ranks: #{my_ranks.join(', ')}"
      end
      
      choices = available_ranks.map { |rank| { name: "#{rank}", value: rank } }
      prompt.select("🎯 What rank do you want to ask for?", choices)
    end
  end
  
  def choose_target(other_players, prompt = nil)
    if bot?
      # Bot uses intelligence to choose the best target
      other_players.sample # Fallback to random if no intelligence available
    else
      # Human player input using TTY::Prompt
      choices = other_players.map do |player|
        { name: "#{player.name} 🤖 (#{player.hand_size} cards)", value: player }
      end
      prompt.select("👥 Choose a player to ask:", choices)
    end
  end

  def choose_intelligent_target(rank, suit, other_players)
    return other_players.sample unless bot?
    
    # Use advanced targeting logic
    get_best_target_for_rank_and_suit(rank, suit, other_players)
  end
  
  def choose_suit_to_ask(rank, prompt = nil)
    if bot?
      # Bot chooses intelligently based on what they know
      my_suits_for_rank = @hand.select { |card| card.rank == rank }.map(&:suit)
      available_suits = Card::SUITS - my_suits_for_rank
      return available_suits.sample if available_suits.empty?
      
      # Advanced priority: suits we already have (to complete books faster)
      # if we know someone has multiple cards of this rank
      if my_suits_for_rank.size >= 2
        priority_suits_same_rank = available_suits.select do |suit|
          @known_cards.any? do |player_name, known_ranks|
            likely_has_multiple_cards_of_rank?(player_name, rank) &&
            !(@given_cards_history[player_name] && 
              @given_cards_history[player_name][rank] && 
              @given_cards_history[player_name][rank].include?(suit))
          end
        end
        return priority_suits_same_rank.sample unless priority_suits_same_rank.empty?
      end
      
      # Medium priority: suits that we know other players have
      priority_suits = available_suits.select do |suit|
        @known_cards.any? do |player_name, known_ranks|
          known_ranks[rank] && known_ranks[rank].include?(suit)
        end
      end
      
      priority_suits.empty? ? available_suits.sample : priority_suits.sample
    else
      # Human player input using TTY::Prompt
      my_suits_for_rank = @hand.select { |card| card.rank == rank }.map(&:suit)
      available_suits = Card::SUITS - my_suits_for_rank
      
      puts "🃏 You have #{rank} in: #{my_suits_for_rank.map { |s| "#{s} #{Card::SUIT_ICONS[s]}" }.join(', ')}"
      puts "📋 You need #{rank} in: #{available_suits.map { |s| "#{s} #{Card::SUIT_ICONS[s]}" }.join(', ')}"
      
      choices = available_suits.map do |suit|
        icon = Card::SUIT_ICONS[suit]
        { name: "#{suit} #{icon}", value: suit }
      end
      prompt.select("🃏 Choose a suit to ask for:", choices)
    end
  end

  def has_rank_and_suit?(rank, suit)
    @hand.any? { |card| card.rank == rank && card.suit == suit }
  end

  def give_cards_of_rank_and_suit(rank, suit)
    cards_to_give = @hand.select { |card| card.rank == rank && card.suit == suit }
    @hand.reject! { |card| card.rank == rank && card.suit == suit }
    cards_to_give
  end

  def explain_bot_reasoning(rank, suit, target)
    return unless bot?
    
    reasoning = []
    
    # Check if we know the target has this card
    if likely_has_card?(target.name, rank, suit)
      reasoning << "🧠 I saw #{target.name} receive #{rank}#{Card::SUIT_ICONS[suit]} before"
    end
    
    # Check advanced reasoning: multiple cards of same rank
    if likely_has_multiple_cards_of_rank?(target.name, rank)
      reasoning << "🎯 #{target.name} likely has multiple #{rank}s (strategic targeting)"
    end
    
    # Check if this leverages our multiple cards strategy
    my_suits_for_rank = @hand.select { |card| card.rank == rank }.map(&:suit)
    if my_suits_for_rank.size >= 2 && likely_has_multiple_cards_of_rank?(target.name, rank)
      reasoning << "⚡ High probability play: I have #{my_suits_for_rank.size} #{rank}s, they likely have more"
    end
    
    # Check if they haven't given it away
    if @given_cards_history[target.name] && 
       @given_cards_history[target.name][rank] && 
       @given_cards_history[target.name][rank].include?(suit)
      reasoning << "🤔 But #{target.name} already gave away #{rank}#{Card::SUIT_ICONS[suit]}"
    elsif @known_cards[target.name] && 
          @known_cards[target.name][rank] && 
          @known_cards[target.name][rank].include?(suit)
      reasoning << "🎯 Confirmed target based on card tracking!"
    end
    
    # Check if this completes a book
    if my_suits_for_rank.size == 3
      reasoning << "📚 This would complete my #{rank} book!"
    elsif my_suits_for_rank.size == 2
      reasoning << "📖 Getting closer to completing #{rank} book (#{my_suits_for_rank.size}/4)"
    end
    
    unless reasoning.empty?
      puts "   💭 #{reasoning.join(' ')}"
    end
  end

  private
  
  def check_for_books
    rank_counts = @hand.group_by(&:rank)
    
    rank_counts.each do |rank, cards|
      if cards.size == 4
        @books << cards
        @hand.reject! { |card| card.rank == rank }
        @score += 1
        puts "🎉 #{@name} completed a book of #{rank}s! Current score: #{@score} 📚"
      end
    end
  end
end
