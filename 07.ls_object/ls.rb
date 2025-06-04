#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'command_line_options'
require_relative 'file_entry'
require_relative 'directory_entry'
require 'etc'

class Ls
  COL_NUM = 3
  GAP = 3

  def initialize(argv)
    @options = CommandLineOptions.new(argv)
    paths = filter_paths(@options.paths)
    paths.sort!
    paths.reverse! if @options.reverse
    dir_paths, file_paths = paths.partition { |path| File.directory?(path) }
    @file_entries = file_paths.map { |file_path| FileEntry.new(file_path) }
    @dir_entries  = dir_paths.map  { |dir_path|  DirectoryEntry.new(dir_path, @options) }
  end

  def print
    if @options.long
      print_long
    else
      print_short
    end
  end

  private

  def filter_paths(paths)
    paths.map do |path|
      if File.exist?(path)
        path
      else
        puts "ls: #{path}: No such file or directory"
      end
    end.compact
  end

  def print_short
    print_columns(@file_entries) unless @file_entries.empty?
    puts if @file_entries.any? && @dir_entries.any?

    @dir_entries.each_with_index do |directory, idx|
      print_header(directory.path, idx) if @dir_entries.length + @file_entries.length > 1
      print_columns(directory.file_entries)
    end
  end

  def print_long
    print_stats(@file_entries) unless @file_entries.empty?
    puts if @file_entries.any? && @dir_entries.any?

    @dir_entries.each_with_index do |directory, idx|
      print_header(directory.path, idx) if @dir_entries.length + @file_entries.length > 1
      puts "total #{directory.blocks}"
      print_stats(directory.file_entries)
    end
  end

  def print_columns(files)
    paths = files.map(&:path)
    col_width = paths.map(&:length).max + GAP
    row_num = (paths.length / COL_NUM.to_f).ceil

    row_num.times do |row|
      line = (0...COL_NUM).map do |col|
        idx = row + row_num * col
        item = paths[idx]
        item&.ljust(col_width)
      end.compact.join
      puts line
    end
  end

  def print_header(path, idx)
    puts unless idx.zero?
    puts "#{path}:"
  end

  def print_stats(files)
    max_lengths = {
      nlink: files.map { |file| file.nlink.to_s.length }.max,
      size: files.map { |file| file.size.to_s.length }.max,
      uid: files.map { |file| file.uid.length }.max,
      gid: files.map { |file| file.gid.length }.max
    }
    files.each do |file|
      puts [
        file.mode,
        file.nlink.to_s.rjust(max_lengths[:nlink] + 1),
        file.uid.ljust(max_lengths[:uid] + 1),
        file.gid.ljust(max_lengths[:gid] + 1),
        file.size.to_s.rjust(max_lengths[:size]),
        file.mtime.strftime('%_m %e %H:%M'),
        file.path,
        file.symlink? ? "-> #{file.readlink}" : nil
      ].compact.join(' ')
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  ls = Ls.new(ARGV)
  ls.print
end
