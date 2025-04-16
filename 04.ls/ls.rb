#!/usr/bin/env ruby

col_num = 3
gap = 2

target_path = !ARGV[0].nil? ? ARGV[0] : "."
target_path = target_path.delete_suffix('/')

item_list_with_path = Dir.glob("#{target_path}/*")

item_list = item_list_with_path.map{ |v| v.split('/').last}
max_length = item_list.map{ |v| v.length}.max

row_num = (item_list.length / col_num.to_f).ceil

row_num.times do |r|
  line = ""
  col_num.times do |c|
    item = item_list[r + row_num * c]
    next unless !item.nil?
    line << item.ljust(max_length + gap)
  end
  puts line
end