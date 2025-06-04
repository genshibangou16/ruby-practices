#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'command_line_options'
require_relative 'file_entry'
require_relative 'directory_entry'
require_relative 'long_formatter'
require_relative 'short_formatter'
require 'etc'

class Ls
  def initialize(argv)
    @options = CommandLineOptions.new(argv)
    paths, @invalid_paths = @options.paths.partition { |path| File.exist?(path) }
    paths.sort!
    paths.reverse! if @options.reverse
    dir_paths, file_paths = paths.partition { |path| File.directory?(path) }
    @file_entries = file_paths.map { |file_path| FileEntry.new(file_path) }
    @dir_entries  = dir_paths.map  { |dir_path|  DirectoryEntry.new(dir_path, @options) }
  end

  def print
    formatter_class = @options.long ? LongFormatter : ShortFormatter
    formatter = formatter_class.new(dir_entries: @dir_entries, file_entries: @file_entries, invalid_paths: @invalid_paths)
    puts formatter
  end
end

if __FILE__ == $PROGRAM_NAME
  ls = Ls.new(ARGV)
  ls.print
end
