# frozen_string_literal: true

require_relative 'file_ls'

class Directory < Array
  attr_reader :path

  def initialize(path, reverse: false, all: false)
    @path = path
    flag_bits = all ? File::FNM_DOTMATCH : 0
    children_paths = Dir.glob(File.join(path, '*'), flag_bits)
    children_paths.sort!
    children_paths.reverse! if reverse
    super(children_paths.map { |children_path| FileLs.new(children_path, in_dir: true) })
  end

  def paths
    map(&:path)
  end

  def size_max_length
    map { |file| file.stat.size.to_s.length }.max
  end

  def uid_max_length
    map { |file| Etc.getpwuid(file.stat.uid).name.length }.max
  end

  def gid_max_length
    map { |file| Etc.getgrgid(file.stat.gid).name.length }.max
  end

  def nlink_max_length
    map { |file| file.stat.nlink.to_s.length }.max
  end

  def total
    map { |file| file.stat.blocks }.sum
  end
end
