#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COL_NUM = 3
GAP = 3

def main
  params = parse_args
  target_paths = ARGV.empty? ? ['.'] : ARGV
  target_paths.sort!
  target_paths.reverse! if params[:r]
  files, directories = target_paths.partition { |path| File.file?(path) }

  if params[:l]
    print_long(files, directories, params)
  else
    print_short(files, directories, params)
  end
end

def parse_args
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| v }
  opt.on('-r') { |v| v }
  opt.on('-l') { |v| v }
  opt.parse!(ARGV, into: params)
  params
end

def print_long(files, directories, params)
  unless files.empty?
    files.each { |f| puts f }
    puts unless directories.empty?
  end

  directories.each_with_index do |path, idx|
    puts_header(path, idx) if files.length + directories.length > 1
    files_in_dir = get_files_on_path(path, params)
    files_in_dir.each { |f| puts f }
  end
end

def print_short(files, directories, params)
  print_columns(files) unless files.empty?
  puts if directories.any? && files.any?

  directories.each_with_index do |path, idx|
    puts_header(path, idx) if files.length + directories.length > 1
    files_in_dir = get_files_on_path(path, params)
    print_columns(files_in_dir)
  end
end

def puts_header(path, idx)
  puts unless idx.zero?
  puts "#{path}:"
end

def get_files_on_path(path, params)
  path = File.join(path, '*')
  flag_bits = params[:a] ? File::FNM_DOTMATCH : 0
  files = Dir.glob(path, flag_bits)
  files.reverse! if params[:r]
  files.map { |f| File.basename(f) }
end

def print_columns(files)
  col_width = files.map(&:length).max + GAP
  row_num = (files.length / COL_NUM.to_f).ceil

  row_num.times do |row|
    line = (0...COL_NUM).map do |col|
      idx = row + row_num * col
      item = files[idx]
      item&.ljust(col_width)
    end.compact.join
    puts line
  end
end

main
