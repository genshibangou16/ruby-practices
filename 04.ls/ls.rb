#!/usr/bin/env ruby
# frozen_string_literal: true

COL_NUM = 3
GAP = 2

target_path = ARGV[0].nil? ? '.' : ARGV[0]
target_path = File.join(target_path, '*')

item_list_with_path = Dir.glob(target_path)

item_list = item_list_with_path.map { |v| v.split('/').last }
max_length = item_list.map(&:length).max

row_num = (item_list.length / COL_NUM.to_f).ceil

row_num.times do |r|
  line = ''
  COL_NUM.times do |c|
    item = item_list[r + row_num * c]
    next if item.nil?

    line << item.ljust(max_length + GAP)
  end
  puts line
end
