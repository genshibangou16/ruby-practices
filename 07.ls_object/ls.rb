#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'options'
require 'etc'
require_relative 'files'
require_relative 'directories'

class Ls
  COL_NUM = 3
  GAP = 3

  def initialize(argv)
    @options = Options.new(argv)
    directory_paths, file_paths = @options.paths.partition { |path| File.directory?(path) }
    @files = Files.new(file_paths, reverse: @options.reverse)
    @directories = Directories.new(directory_paths, reverse: @options.reverse, all: @options.all)
  end

  def print
    if @options.long
      print_long
    else
      print_short
    end
  end

  private

  def print_short
    print_columns(@files) unless @files.empty?
    puts if @directories.any? && @files.any?

    @directories.each_with_index do |directory, idx|
      print_header(directory.path, idx) if @files.length + @directories.length > 1
      print_columns(directory)
    end
  end

  def print_long
    print_stats(@files) unless @files.empty?
    puts if @directories.any? && @files.any?

    @directories.each_with_index do |directory, idx|
      print_header(directory.path, idx) if @files.length + @directories.length > 1
      puts "total #{directory.total}"
      print_stats(directory)
    end
  end

  def print_columns(targets)
    list = targets.paths
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

  def print_header(path, idx)
    puts unless idx.zero?
    puts "#{path}:"
  end

  def print_stats(targets)
    max_lengths = {
      nlink: targets.nlink_max_length,
      size: targets.size_max_length,
      uid: targets.uid_max_length,
      gid: targets.gid_max_length
    }
    targets.each do |target|
      puts [
        target.mode,
        target.stat.nlink.to_s.rjust(max_lengths[:nlink] + 1),
        Etc.getpwuid(target.stat.uid).name.ljust(max_lengths[:uid] + 1),
        Etc.getgrgid(target.stat.gid).name.ljust(max_lengths[:gid] + 1),
        target.stat.size.to_s.rjust(max_lengths[:size]),
        target.stat.mtime.strftime('%_m %e %H:%M'),
        target.path,
        target.stat.symlink? ? "-> #{File.readlink(target.path)}" : nil
      ].compact.join(' ')
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  ls = Ls.new(ARGV)
  ls.print
end
