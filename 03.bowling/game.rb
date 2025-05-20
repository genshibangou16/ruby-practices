# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks_str)
    throw_count = 0
    marks = marks_str.split(',')
    @frame = (1..10).map do
      frame = Frame.new(
        marks[throw_count],
        marks[throw_count + 1],
        marks[throw_count + 2] || nil
      )
      throw_count += frame.step
      frame
    end
  end

  def score
    @frame.map(&:score).sum
  end
end
