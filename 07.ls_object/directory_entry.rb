# frozen_string_literal: true

require_relative 'file_entry'

class DirectoryEntry
  attr_reader :path, :file_entries

  def initialize(path, options)
    @path = path
    flag_bits = options.all ? File::FNM_DOTMATCH : 0
    children_paths = Dir.glob(File.join(path, '*'), flag_bits)
    children_paths.sort!
    children_paths.reverse! if options.reverse
    @file_entries = children_paths.map { |children_path| FileEntry.new(children_path, in_dir: true) }
  end

  def blocks
    file_entries.map(&:blocks).sum
  end
end
