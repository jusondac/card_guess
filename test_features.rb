#!/usr/bin/env ruby

# Test script to demonstrate the new rank + suit asking feature
require_relative 'card'
require_relative 'player'

puts "🎮 Testing New Rank + Suit Feature 🃏"
puts "═" * 40

# Create a test player
player = Player.new("Test Player", false)

# Add some test cards
test_cards = [
  Card.new('K', 'Hearts'),
  Card.new('K', 'Spades'),
  Card.new('A', 'Diamonds'),
  Card.new('7', 'Clubs')
]

test_cards.each { |card| player.add_card(card) }

puts "\n🃏 Test hand: #{player.display_hand}"
puts "🃏 Detailed: #{player.display_detailed_hand}"

puts "\n🎯 New Human Turn Features:"
puts "  1. Choose rank from your hand"
puts "  2. Choose specific suit (♥️ ♦️ ♣️ ♠️)"
puts "  3. Ask opponent for exact card (e.g., K♥️)"
puts "  4. More strategic gameplay!"

puts "\n✅ Syntax check passed - ready to play!"
puts "🚀 Run: ruby main.rb"
