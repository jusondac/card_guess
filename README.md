# Card Collection Game 🃏

A beautiful, interactive Ruby card game with stunning visual design and intelligent gameplay! This is a "Go Fish" style card game where players try to collect complete sets (books) of 4 cards with the same rank.

## ✨ Features

- 🎨 **Beautiful card icons** (♥️ ♦️ ♣️ ♠️) for immersive gameplay
- 🤖 **Intelligent bot players** with strategic decision-making and realistic delays
- 🧠 **Bot memory system** - bots remember and use information from card exchanges
- 📊 **Live game status** showing hands, scores, and remaining deck
- 🎯 **Interactive prompts** with emoji guides and clear instructions
- ✅ **Robust input validation** with helpful error messages
- 🎲 **Elegant turn display** with beautiful borders and formatting
- 🔄 **Auto-restart functionality** to play multiple games

## Game Rules

- 👥 **4 players**: You vs 3 intelligent bot players (Emily, Sarah, Jessica)
- 🃏 **Standard 52-card poker deck** with all 4 suits and 13 ranks each
- 🎯 **Goal**: Collect "books" (complete sets of 4 cards with the same rank) to score points
- 🏆 **Winner**: Player with the most books when the game ends
- 🎴 **Dealing**: Each player receives 13 cards at the start

## How to Play

1. 🎴 Each player is dealt 13 cards from a shuffled 52-card deck
2. 🔄 Players take turns asking other players for specific cards (rank + suit)
3. 👤 **On your turn**:
   - 🃏 View your hand with beautiful card icons and detailed descriptions
   - 🎯 Choose a rank from cards in your hand to ask for
   - 🃏 Choose the specific suit (♥️ ♦️ ♣️ ♠️) you want
   - 👥 Choose which player to ask (only players with cards remaining)
   - ✅ If they have that exact card, they give it to you and you continue your turn
   - ❌ If they don't have that specific card, your turn ends and you draw from the deck
4. 📚 When you collect all 4 cards of the same rank, you automatically score 1 book
5. 🔄 Game continues until all players are out of cards or nearly out
6. 🏆 Player with the most books wins!

## 🚀 How to Run

### Prerequisites
Make sure you have Ruby installed and the required gems:

```bash
# Install bundler if you don't have it
gem install bundler

# Install dependencies
bundle install
```

### Start the Game
```bash
ruby main.rb
```

## 🎮 Demo & Testing

```bash
ruby demo.rb          # See the new features in action
ruby test_features.rb  # Run feature tests
```

## 📁 Project Structure

- `main.rb` - Game launcher with restart functionality and menu system
- `game.rb` - Core game engine, turn management, and game flow logic
- `player.rb` - Player classes with human/bot behavior and AI intelligence
- `card.rb` - Card representation with beautiful icons and suit symbols
- `demo.rb` - Feature demonstration and showcase
- `test_features.rb` - Feature testing and validation
- `Gemfile` - Ruby gem dependencies (tty-prompt, byebug)
- `README.md` - This comprehensive documentation

## 🤖 Bot Intelligence Features

The bot players are equipped with:

- 🧠 **Memory System**: Remember card exchanges between other players
- 🎯 **Strategic Targeting**: Choose targets based on known information
- 💭 **Reasoning Display**: Show their thought process during turns
- ⏱️ **Realistic Timing**: Natural delays that simulate human thinking
- 🎲 **Smart Card Selection**: Prioritize ranks they're likely to complete

## 🎯 Example Gameplay

```
🎮 Welcome to the Card Collection Game! 🃏
═══════════════════════════════════════════════════════
🎯 Rules: Collect sets of 4 cards with the same rank to score points.
🤝 Ask other players for cards. If they have them, they give them to you and you continue.
🛑 If they don't have them, your turn ends.
═══════════════════════════════════════════════════════

🎴 Cards dealt! Each player has 13 cards.

📈 Current Game Status:
   👤 You: 13 cards, 0 books , [Hidden hand - select to see details]
   🤖 Emily: 13 cards, 0 books 📚, [Hidden hand]
   🤖 Sarah: 13 cards, 0 books 📚, [Hidden hand]  
   🤖 Jessica: 13 cards, 0 books 📚, [Hidden hand]
🎴 Cards left in deck: 0

🎲 You's turn

🃏 Your hand: 3♥️ 7♣️ K♠️ A♦️ Q♠️ 5♥️ 9♦️ 2♣️ J♥️ 4♠️ 8♦️ 6♣️ 10♥️
🃏 Detailed view: 3 of Hearts ♥️, 7 of Clubs ♣️, K of Spades ♠️, A of Diamonds ♦️, Q of Spades ♠️, 5 of Hearts ♥️, 9 of Diamonds ♦️, 2 of Clubs ♣️, J of Hearts ♥️, 4 of Spades ♠️, 8 of Diamonds ♦️, 6 of Clubs ♣️, 10 of Hearts ♥️

📋 Available ranks to ask for: 3, 7, K, A, Q, 5, 9, 2, J, 4, 8, 6, 10
🎯 What rank do you want to ask for? K

🃏 You have: K♠️
🃏 Choose a suit to ask for:
  1. Hearts ♥️
  2. Diamonds ♦️  
  3. Clubs ♣️
  4. Spades ♠️ (you already have this)
🎲 Enter number (1-4): 2

👥 Choose a player to ask:
  1. Emily 🤖 (13 cards)
  2. Sarah 🤖 (13 cards)
  3. Jessica 🤖 (13 cards)
🎲 Enter number (1-3): 1

✅ Emily gives you the K♦️!

🃏 Choose a suit to ask for:
  1. Hearts ♥️
  2. Diamonds ♦️ (you already have this)
  3. Clubs ♣️
  4. Spades ♠️ (you already have this)
🎲 Enter number (1-4): 1

✅ Emily gives you the K♥️!

... [game continues]
```

## 🎊 Key Improvements & Features

### Visual & UX Enhancements
- **Stunning Card Icons**: Real suit symbols (♥️ ♦️ ♣️ ♠️) replace plain text
- **Strategic Gameplay**: Ask for specific cards by both rank and suit
- **Interactive Prompts**: Clear, emoji-guided interface with numbered choices
- **Live Status Display**: See all players' card counts, books, and deck status
- **Beautiful Formatting**: Elegant borders, icons, and visual hierarchy

### Intelligent Bot System  
- **Memory & Observation**: Bots remember card exchanges and use that info strategically
- **Realistic Behavior**: Natural delays and explanations of bot reasoning
- **Smart Targeting**: Bots choose targets based on probability and known information
- **Varied Personalities**: Each bot (Emily, Sarah, Jessica) has distinct behavior

### Technical Improvements
- **Robust Input Handling**: Graceful error recovery and validation
- **Modular Design**: Clean separation of game logic, player behavior, and card representation
- **Restart Functionality**: Play multiple games without restarting the program
- **Comprehensive Testing**: Demo and test files for feature validation

## 🏆 Game End Conditions

The game ends when:
- All players have formed all possible books (ideal ending)
- The deck is empty and players have 1 or fewer cards remaining
- No meaningful plays can be made

Victory goes to the player with the most books! 🎯

---

**Enjoy the enhanced Card Collection Game experience!** 🎮✨

*Built with Ruby, featuring the `tty-prompt` gem for beautiful interactive prompts.*
