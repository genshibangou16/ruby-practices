# frozen_string_literal: true

class Files < Array
  def initialize(paths, reverse: false)
    paths.sort!
    paths.reverse! if reverse
    super(paths.map { |path| FileLs.new(path) })
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
end
