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
        marks[throw_count + 2]
      )
      throw_count += frame.shot_count
      frame
    end
  end

  def score
    @frame.sum(&:score)
  end
end
