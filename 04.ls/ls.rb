#!/usr/bin/env ruby
# frozen_string_literal: true

COL_NUM = 3
GAP = 2

target_paths = ARGV.empty? ? ['.'] : ARGV

def puts_files(path)
  target_path = File.join(path, '*')
  item_list_with_path = Dir.glob(target_path)
  item_list = item_list_with_path.map { |i| File.basename(i) }
  max_length = item_list.map(&:length).max
  row_num = (item_list.length / COL_NUM.to_f).ceil

  row_num.times do |row|
    line = ''
    COL_NUM.times do |col|
      item = item_list[row + row_num * col]
      next if item.nil?

      line += item.ljust(max_length + GAP)
    end
    puts line
  end
end

target_paths.each_with_index do |p, idx|
  puts if target_paths.length > 1 && idx.positive?
  puts "#{p}:" if target_paths.length > 1

  puts_files(p)
end
