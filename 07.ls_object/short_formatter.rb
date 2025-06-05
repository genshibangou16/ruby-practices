# frozen_string_literal: true

require_relative 'formatter'

class ShortFormatter < Formatter
  COL_NUM = 3
  GAP = 3

  private

  def format(files)
    paths = files.map(&:path)
    col_width = paths.map(&:length).max + GAP
    row_num = (paths.length / COL_NUM.to_f).ceil

    row_num.times do |row|
      line = (0...COL_NUM).map do |col|
        idx = row + row_num * col
        item = paths[idx]
        item&.ljust(col_width)
      end.compact.join
      @lines.push line
    end
  end
end
