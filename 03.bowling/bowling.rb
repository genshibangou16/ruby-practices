# frozen_string_literal: true

require_relative 'game'

throws_str = ARGV[0]
game = Game.new(throws_str)
puts game.score
