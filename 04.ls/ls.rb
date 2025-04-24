#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COL_NUM = 3
GAP = 3

def main
  params = parse_args
  target_paths = ARGV.empty? ? ['.'] : ARGV
  target_paths.each_with_index do |path, idx|
    if File.file?(path)
      puts path
      next
    end
    puts_header(path, idx) if target_paths.length > 1
    puts_files_on_path(path, params)
  end
end

def parse_args
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| v }
  opt.parse!(ARGV, into: params)
  params
end

def puts_header(path, idx)
  puts if idx.positive?
  puts "#{path}:"
end

def puts_files_on_path(path, params)
  path = File.join(path, '*')
  file_list = get_file_list(path, params)
  max_filename_length = file_list.map(&:length).max
  row_num = (file_list.length / COL_NUM.to_f).ceil

  row_num.times do |row|
    line = ''
    COL_NUM.times do |col|
      item = file_list[row + row_num * col]
      next if item.nil?

      line += item.ljust(max_filename_length + GAP)
    end
    puts line
  end
end

def get_file_list(path, params)
  file_list = params[:a] ? Dir.glob(path, File::FNM_DOTMATCH) : Dir.glob(path)
  file_list.map { |i| File.basename(i) }
end

main
