# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if @mark == 'X'
    return 0 unless @mark

    @mark.to_i
  end
end
