# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.mark != 'X' && @first_shot.score + @second_shot.score == 10
  end

  def score
    strike? || spare? ? @first_shot.score + @second_shot.score + @third_shot.score : @first_shot.score + @second_shot.score
  end

  def shot_count
    strike? ? 1 : 2
  end
end
