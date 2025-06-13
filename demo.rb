#!/usr/bin/env ruby

# Demo script to show the game's new features
puts "🎮 Card Collection Game - Feature Demo 🃏"
puts "═" * 50

# Show card representation
require_relative 'card'

puts "\n🃏 Card Representation with Icons:"
sample_cards = [
  Card.new('K', 'Hearts'),
  Card.new('A', 'Spades'), 
  Card.new('7', 'Diamonds'),
  Card.new('Q', 'Clubs')
]

sample_cards.each do |card|
  puts "  #{card} (#{card.detailed_string})"
end

puts "\n🎯 Game Features:"
puts "  ✅ Beautiful card icons (♥️ ♦️ ♣️ ♠️)"
puts "  ✅ Interactive prompts with emojis"
puts "  ✅ Sleep delays for bot turns (easier to follow)"
puts "  ✅ Game status display between turns"
puts "  ✅ Input validation and error handling"
puts "  ✅ Elegant turn formatting with borders"

puts "\n🚀 Ready to play! Run: ruby main.rb"
puts "═" * 50
