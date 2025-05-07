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
    file_exists = File.exist?(item)
    puts "ls: #{item}: No such file or directory" unless file_exists
    file_exists
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
    stats = get_stats(sort(files_in_dir, params[:r]))
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
    puts [
      parse_mode(item.mode),
      item.nlink.to_s.rjust(2),
      Etc.getpwuid(item.uid).name.ljust(max_lengths[:uid] + 1),
      Etc.getgrgid(item.gid).name.ljust(max_lengths[:gid] + 1),
      item.size.to_s.rjust(max_lengths[:size]),
      item.mtime.strftime('%_m %e %H:%M'),
      only_basename ? File.basename(key) : key,
      item.symlink? ? "-> #{File.readlink(key)}" : nil
    ].join(' ')
  end
end

def parse_mode(mode)
  type = get_filetype(mode)
  permissions = %w[t s s].map.with_index do |char, shift_width|
    get_permission(mode, char, shift_width)
  end.reverse
  [type, permissions].join
end

def get_filetype(mode)
  mode &= 0o170000
  case mode
  when 0o010000
    'p'
  when 0o020000
    'c'
  when 0o040000
    'd'
  when 0o060000
    'b'
  when 0o100000
    '-'
  when 0o120000
    'l'
  when 0o140000
    's'
  else
    abort 'Invalid value for filetype.'
  end
end

def get_permission(mode, char, shift_width)
  permission_bits = mode >> shift_width * 3
  special_flag = (mode >> 9 + shift_width) & 1 == 1

  r         = (permission_bits >> 2)  & 1 == 1 ? 'r' : '-'
  w         = (permission_bits >> 1)  & 1 == 1 ? 'w' : '-'
  exec_flag = permission_bits         & 1 == 1

  x = if special_flag
        exec_flag ? char : char.upcase
      else
        exec_flag ? 'x' : '-'
      end
  [r, w, x].join
end

main
