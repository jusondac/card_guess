require_relative 'card'
require_relative 'player'
require 'tty-prompt'
require 'byebug'

# Main game class that manages the card game
class CardGame
  def initialize
    @deck = create_deck
    @players = [
      Player.new("You", false),
      Player.new("Emily", true),
      Player.new("Sarah", true),
      Player.new("Jessica", true)
    ]
    @current_player_index = 0
    @prompt = TTY::Prompt.new
  end
  
  def play
    puts "🎮 Welcome to the Card Collection Game! 🃏"
    puts "═" * 50
    puts "🎯 Rules: Collect sets of 4 cards with the same rank to score points."
    puts "🤝 Ask other players for cards. If they have them, they give them to you and you continue."
    puts "🛑 If they don't have them, your turn ends."
    puts "═" * 50
    puts ""
    
    deal_cards
    
    until game_over?
      current_player = @players[@current_player_index]
      take_turn(current_player)
      @current_player_index = (@current_player_index + 1) % @players.size
    end
    
    end_game
  end
  
  private
  
  def create_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck.shuffle
  end
  
  def deal_cards
    # Deal 13 cards to each player (52 cards / 4 players = 13 each)
    cards_per_player = 13
    
    @players.each do |player|
      cards_per_player.times do
        player.add_card(@deck.pop) if @deck.any?
      end
    end
    
    # Let bots observe some initial information from visible exchanges during setup
    # (This simulates them paying attention to the dealing and initial book formations)
    
    puts "🎴 Cards dealt! Each player has #{cards_per_player} cards."
    display_game_status
  end
  
  def take_turn(player)
    return if player.hand_size == 0
    
    puts "🎲 #{player.name}'s turn"
    
    if player.bot?
      sleep(2) # Pause for readability
      bot_turn(player)
      sleep(3) # Pause after bot turn
    else
      human_turn(player)
    end
    
    puts ""
  end
  
  def human_turn(player)
    turn_continues = true
    
    # Show game status at start of human turn
    display_game_status
    
    while turn_continues && player.hand_size > 0
      other_players = @players.reject { |p| p == player }.select { |p| p.hand_size > 0 }
      break if other_players.empty?
      
      # Human players choose both rank and suit
      rank = player.choose_rank_to_ask(@prompt, other_players)
      break if rank.nil? # Handle EOF/exit or no valid ranks
      
      suit = player.choose_suit_to_ask(rank, @prompt)
      break if suit.nil? # Handle EOF/exit
      
      target = player.choose_target(other_players, @prompt)
      break if target.nil? # Handle EOF/exit
      turn_continues = ask_for_specific_card(player, target, rank, suit)
    end
  end
  
  def bot_turn(player)
    turn_continues = true
    
    while turn_continues && player.hand_size > 0
      other_players = @players.reject { |p| p == player }.select { |p| p.hand_size > 0 }
      break if other_players.empty?
      
      rank = player.choose_rank_to_ask(nil, other_players)
      next if rank.nil? # Skip turn if no valid ranks
      
      suit = player.choose_suit_to_ask(rank)
      next if suit.nil? # Skip if no valid suits
      
      # Use intelligent targeting for bots
      target = player.choose_intelligent_target(rank, suit, other_players)
      card_icon = Card::SUIT_ICONS[suit]
      puts "🤖 #{player.name} asks #{target.name} for #{rank}#{card_icon}..."
      
      # Show bot's reasoning
      player.explain_bot_reasoning(rank, suit, target)
      
      sleep(0.8) # Pause for dramatic effect
      turn_continues = ask_for_specific_card(player, target, rank, suit)
      
      if turn_continues
        sleep(0.5) # Short pause between successful asks
      end
    end
  end
  
  def ask_for_cards(asking_player, target_player, rank)
    if target_player.has_rank?(rank)
      cards_given = target_player.give_cards_of_rank(rank)
      asking_player.add_cards(cards_given)
      
      if asking_player.bot?
        puts "✅ #{target_player.name} gives #{cards_given.size} #{rank}(s) to #{asking_player.name}: #{cards_given.map(&:to_s).join(' ')}"
      else
        puts "✅ #{target_player.name} gives you #{cards_given.size} #{rank}(s): #{cards_given.map(&:to_s).join(' ')}"
      end
      
      return true # Continue turn
    else
      if asking_player.bot?
        puts "❌ #{target_player.name} doesn't have any #{rank}s"
      else
        puts "❌ #{target_player.name} doesn't have any #{rank}s. Your turn ends."
      end
      
      # Draw a card if deck is not empty
      if @deck.any?
        drawn_card = @deck.pop
        asking_player.add_card(drawn_card)
        if asking_player.bot?
          puts "🎴 #{asking_player.name} draws a card from the deck"
        else
          puts "🎴 You draw a card from the deck: #{drawn_card}"
        end
      end
      
      return false # End turn
    end
  end

  def ask_for_specific_card(asking_player, target_player, rank, suit)
    if target_player.has_rank_and_suit?(rank, suit)
      cards_given = target_player.give_cards_of_rank_and_suit(rank, suit)
      asking_player.add_cards(cards_given)
      
      # Inform all bots about this card exchange
      @players.each do |observer|
        next unless observer.bot? && observer != asking_player && observer != target_player
        observer.observe_card_exchange(target_player.name, asking_player.name, rank, suit)
      end
      
      card_icon = Card::SUIT_ICONS[suit]
      if asking_player.bot?
        puts "✅ #{target_player.name} gives #{asking_player.name} the #{rank}#{card_icon}!"
      else
        puts "✅ #{target_player.name} gives you the #{rank}#{card_icon}!"
      end
      
      return true # Continue turn
    else
      card_icon = Card::SUIT_ICONS[suit]
      if asking_player.bot?
        puts "❌ #{target_player.name} doesn't have the #{rank}#{card_icon}"
      else
        puts "❌ #{target_player.name} doesn't have the #{rank}#{card_icon}. Your turn ends."
      end
      
      # Draw a card if deck is not empty
      if @deck.any?
        drawn_card = @deck.pop
        asking_player.add_card(drawn_card)
        if asking_player.bot?
          puts "🎴 #{asking_player.name} draws a card from the deck"
        else
          puts "🎴 You draw a card from the deck: #{drawn_card}"
        end
      end
      
      return false # End turn
    end
  end
  
  def game_over?
    # Game ends when all cards are in books or no one has cards
    total_cards_in_hands = @players.sum(&:hand_size)
    total_cards_in_hands == 0 || @deck.empty? && @players.all? { |p| p.hand_size <= 1 }
  end
  
  def end_game
    puts ""
    puts "🏁 " + "═" * 46 + " 🏁"
    puts "🎊                GAME OVER!                🎊"
    puts "🏁 " + "═" * 46 + " 🏁"
    puts ""
    
    puts "📊 Final Scores:"
    @players.each do |player|
      icon = player.bot? ? "🤖" : "👤"
      puts "   #{icon} #{player.name}: #{player.score} books 📚"
    end
    
    winner = @players.max_by(&:score)
    max_score = winner.score
    winners = @players.select { |p| p.score == max_score }
    
    puts ""
    if winners.size == 1
      winner_icon = winner.bot? ? "🤖" : "👑"
      puts "🎉 #{winner_icon} #{winner.name} wins with #{max_score} books! 🏆"
    else
      puts "🤝 It's a tie between: #{winners.map(&:name).join(', ')} with #{max_score} books each! 🏆"
    end
    puts ""
  end

  def display_game_status
    puts "📈 Current Game Status:"
    @players.each do |player|
      icon = player.bot? ? "🤖" : "👤"
      books_icon = "📚" * player.score
      puts "   #{icon} #{player.name}: #{player.hand_size} cards, #{player.score} books #{books_icon}, #{player.display_hand}"
    end
    puts "🎴 Cards left in deck: #{@deck.size}"
    puts ""
  end
end
