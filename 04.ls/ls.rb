#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'
require 'etc'

COL_NUM = 3
GAP = 3

def main
  params = parse_args
  target_paths = ARGV.empty? ? ['.'] : ARGV
  target_paths = check_file_existence(target_paths)
  target_paths = sort(target_paths, params[:r])
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

def check_file_existence(list)
  list.filter do |item|
    is_exist = File.exist?(item)
    puts "ls: #{item}: No such file or directory" unless is_exist
    is_exist
  end
end

def sort(list, reverse)
  list.sort! { |a, b| a.casecmp(b) }
  reverse ? list.reverse : list
end

def print_long(files, directories, params)
  unless files.empty?
    stats = get_stats(files)
    print_stats(list: stats, only_basename: false)
  end
  puts if directories.any? && files.any?

  directories.each_with_index do |path, idx|
    files_in_dir = get_files_on_path(path, params)
    stats = get_stats(files_in_dir)
    total = stats.values.map(&:blocks).sum
    print_header(path, idx) if files.length + directories.length > 1
    puts "total #{total}"
    print_stats(list: stats, only_basename: true)
  end
end

def print_short(files, directories, params)
  print_columns(files) unless files.empty?
  puts if directories.any? && files.any?

  directories.each_with_index do |path, idx|
    print_header(path, idx) if files.length + directories.length > 1
    files_in_dir = get_files_on_path(path, params).map { |f| File.basename(f) }
    print_columns(sort(files_in_dir, params[:r]))
  end
end

def print_header(path, idx)
  puts unless idx.zero?
  puts "#{path}:"
end

def get_files_on_path(path, params)
  path = File.join(path, '*')
  flag_bits = params[:a] ? File::FNM_DOTMATCH : 0
  Dir.glob(path, flag_bits)
end

def print_columns(list)
  col_width = list.map(&:length).max + GAP
  row_num = (list.length / COL_NUM.to_f).ceil

  row_num.times do |row|
    line = (0...COL_NUM).map do |col|
      idx = row + row_num * col
      item = list[idx]
      item&.ljust(col_width)
    end.compact.join
    puts line
  end
end

def get_stats(list)
  stats = {}
  list.each { |item| stats[item] = File.lstat(item) }
  stats
end

def print_stats(list:, only_basename:)
  max_lengths = {
    size: list.values.map { |i| i.size.to_s.length }.max,
    uid: list.values.map { |i| Etc.getpwuid(i.uid).name.length }.max,
    gid: list.values.map { |i| Etc.getgrgid(i.gid).name.length }.max
  }
  list.each do |key, item|
    timestamp = item.mtime.strftime('%_m %e %H:%M')
    symlink_target = item.symlink? ? File.readlink(key) : nil
    puts format(
      "%<mode>s %<nlink>2d %<uid>-#{max_lengths[:uid]}s  %<gid>-#{max_lengths[:gid]}s  %<size>#{max_lengths[:size]}d %<mtime>s %<fname>s%<symlink>s",
      mode: parse_mode(item.mode),
      nlink: item.nlink,
      uid: Etc.getpwuid(item.uid).name,
      gid: Etc.getgrgid(item.gid).name,
      size: item.size,
      mtime: timestamp,
      fname: only_basename ? File.basename(key) : key,
      symlink: symlink_target && " -> #{symlink_target}"
    )
  end
end

def parse_mode(mode)
  mode = mode.to_s(8)

  type = get_filetype(mode[0..-5])
  sticky = get_sticky(mode[-4])
  permissions = mode[-3..].chars.map do |p|
    get_permission(p)
  end
  [type, sticky, permissions].join
end

def get_filetype(octal_digit)
  case octal_digit.to_i
  when 1
    'p'
  when 2
    'c'
  when 4
    'd'
  when 6
    'b'
  when 10
    '-'
  when 12
    'l'
  when 14
    's'
  else
    abort 'Invalid value for filetype.'
  end
end

def get_sticky(octal_digit)
  case octal_digit.to_i
  when 0
    ''
  when 1
    't'
  when 2, 4
    's'
  else
    abort 'Invalid value for sticky bit.'
  end
end

def get_permission(octal_digit)
  binary_digit = octal_digit.to_i.to_s(2)
  r = binary_digit[0].to_i.zero? ? '-' : 'r'
  w = binary_digit[1].to_i.zero? ? '-' : 'w'
  x = binary_digit[2].to_i.zero? ? '-' : 'x'
  [r, w, x].join
end

main
