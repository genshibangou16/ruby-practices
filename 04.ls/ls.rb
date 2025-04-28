#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COL_NUM = 3
GAP = 3

def main
  params = parse_args
  target_paths = ARGV.empty? ? ['.'] : ARGV

  files = target_paths.filter do |path|
    File.file?(path)
  end
  unless files.empty?
    format_list(files)
    puts
  end

  target_paths.each_with_index do |path, idx|
    next if File.file?(path)

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
  format_list(file_list)
end

def format_list(files)
  max_filename_length = files.map(&:length).max
  row_num = (files.length / COL_NUM.to_f).ceil

  row_num.times do |row|
    line = ''
    COL_NUM.times do |col|
      item = files[row + row_num * col]
      next if item.nil?

      line += item.ljust(max_filename_length + GAP)
    end
    puts line
  end
end

def get_file_list(path, params)
  flag_bits = params[:a] ? File::FNM_DOTMATCH : 0
  file_list = Dir.glob(path, flag_bits)
  file_list.map { |i| File.basename(i) }
end

main
