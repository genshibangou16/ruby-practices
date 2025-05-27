# frozen_string_literal: true

require_relative 'game'

input = ARGV[0]
game = Game.new(input)
puts game.score
