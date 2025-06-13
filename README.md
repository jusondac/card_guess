# Card Collection Game 🃏

A beautiful, interactive Ruby card game with icons and engaging gameplay! Based on poker cards where players try to collect sets of 4 cards with the same rank.

## ✨ Features

- 🎨 **Beautiful card icons** (♥️ ♦️ ♣️ ♠️) instead of plain text
- 🤖 **Smart bot players** with realistic turn delays
- 📊 **Live game status** showing cards and scores
- 🎯 **Interactive prompts** with emoji guides
- ✅ **Input validation** with helpful error messages
- 🎲 **Elegant turn display** with bordered formatting

## Game Rules

- 👥 **4 players**: 1 human player (you) and 3 bot players
- 🃏 **Standard 52-card poker deck** with all suits and ranks
- 🎯 **Goal**: Collect "books" (sets of 4 cards with the same rank) to score points
- 🏆 **Winner**: Player with the most books at game end

## How to Play

1. 🎴 Each player is dealt 7 cards (or fewer if there aren't enough cards)
2. 🔄 Players take turns asking other players for cards of a specific rank
3. 👤 **On your turn**:
   - 🃏 View your hand with beautiful card icons
   - 🎯 Choose a rank from your hand to ask for
   - 🃏 Choose a specific suit (♥️ ♦️ ♣️ ♠️) 
   - 👥 Choose which player to ask
   - ✅ If they have that exact card, they give it to you and you continue
   - ❌ If they don't have that specific card, your turn ends and you draw a card
4. 📚 When you collect all 4 cards of the same rank, you automatically score 1 point
5. 🔄 Game continues until all cards are collected or no meaningful plays remain
6. 🏆 Player with the most points (books) wins!

## 🚀 How to Run

```bash
ruby main.rb
```

## 🎮 Demo

```bash
ruby demo.rb  # See the new features in action
```

## 📁 Files

- `main.rb` - Game launcher with restart functionality
- `game.rb` - Core game engine and turn management  
- `player.rb` - Player logic (human and bot behavior)
- `card.rb` - Card representation with beautiful icons
- `demo.rb` - Feature demonstration
- `README.md` - This documentation

## 🎯 Example Gameplay

```
🃏 Your hand: 3♥️ 7♣️ K♠️ A♦️
🃏 Detailed: 3 of Hearts ♥️, 7 of Clubs ♣️, K of Spades ♠️, A of Diamonds ♦️
📋 Available ranks: 3, 7, K, A
🎯 What rank do you want to ask for? K

🃏 Choose a suit to ask for:
  1. Hearts ♥️
  2. Diamonds ♦️
  3. Clubs ♣️
  4. Spades ♠️
🎲 Enter number (1-4): 3

👥 Choose a player to ask:
  1. Bot A 🤖 (6 cards)
  2. Bot B 🤖 (7 cards)  
  3. Bot C 🤖 (5 cards)
🎲 Enter number (1-3): 1

✅ Bot A gives you the K♣️!
```

## 🎊 New Improvements

- **Visual Enhancement**: Card icons replace plain text
- **Strategic Gameplay**: Ask for specific cards (rank + suit)
- **Better UX**: Clear prompts with emoji guides
- **Bot Intelligence**: Realistic delays for bot turns
- **Status Display**: Live game state between turns
- **Error Handling**: Graceful input validation
- **Polish**: Beautiful borders and formatting

Enjoy the enhanced gaming experience! 🎮✨
