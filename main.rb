#!/usr/bin/env ruby

require_relative 'game'

# Main entry point for the card game
puts "🎮 Starting Card Collection Game... 🃏"
puts "💡 Press Ctrl+C to quit at any time."
puts ""

begin
  game = CardGame.new
  game.play
rescue Interrupt
  puts ""
  puts "👋 Thanks for playing! Goodbye! 🎊"
  exit
end

puts "🔄 Would you like to play again? (y/n) 🎯"
input = gets
if input && input.chomp.downcase == 'y'
  puts "🚀 Restarting game..."
  exec($0)  # Restart the game
else
  puts "👋 Thanks for playing! 🎊"
end
