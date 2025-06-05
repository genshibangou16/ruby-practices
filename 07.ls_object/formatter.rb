# frozen_string_literal: true

class Formatter
  def initialize(dir_entries:, file_entries:, invalid_paths:)
    @lines = []
    @dir_entries = dir_entries
    @file_entries = file_entries
    @invalid_paths = invalid_paths
  end

  def lines
    @invalid_paths.each do |path|
      @lines.push "ls: #{path}: No such file or directory"
    end

    format(@file_entries) unless @file_entries.empty?
    @lines.push '' if contains_files_and_dirs?

    @dir_entries.each_with_index do |directory, idx|
      header(directory.path, idx) if more_than_one_entry?
      total_blocks(directory)
      format(directory.file_entries)
    end

    @lines
  end

  private

  def format
    raise NotImplementedError
  end

  def total_blocks(directory); end

  def more_than_one_entry?
    @dir_entries.length + @file_entries.length > 1
  end

  def contains_files_and_dirs?
    @file_entries.any? && @dir_entries.any?
  end

  def header(path, idx)
    @lines.push '' unless idx.zero?
    @lines.push "#{path}:"
  end
end
