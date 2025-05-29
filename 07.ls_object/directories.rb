# frozen_string_literal: true

require_relative 'directory'

class Directories < Array
  def initialize(paths, reverse: false, all: false)
    paths.sort!
    paths.reverse! if reverse
    super(paths.map { |path| Directory.new(path, reverse:, all:) })
  end

  def paths
    map(&:path)
  end
end
