#!/usr/bin/env ruby
# frozen_string_literal: true

COL_NUM = 3
GAP = 2

target_paths = ARGV.empty? ? ['.'] : ARGV

class Ls
  def initialize(path)
    @path = path
  end

  def print
    target_path = File.join(@path, '*')
    item_list_with_path = Dir.glob(target_path)
    item_list = item_list_with_path.map { |i| i.split('/').last }
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
end

target_paths.map.with_index do |p, idx|
  puts "\n" if target_paths.length > 1 && idx.positive?
  puts "#{p}:\n" if target_paths.length > 1

  ls = Ls.new(p)
  ls.print
end
