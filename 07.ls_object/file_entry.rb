# frozen_string_literal: true

require_relative 'permission'

class FileEntry
  attr_reader :path

  def initialize(path, in_dir: false)
    @full_path = path
    @path = in_dir ? File.basename(path) : path
    @stat = File.lstat(path)
  end

  def mode
    [type, permissions].join
  end

  def nlink
    @stat.nlink
  end

  def uid
    Etc.getpwuid(@stat.uid).name
  end

  def gid
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end

  def symlink?
    @stat.symlink?
  end

  def blocks
    @stat.blocks
  end

  def readlink
    return unless symlink?

    File.readlink(@full_path)
  end

  private

  def type
    ftype = File.ftype(@full_path)
    case ftype
    when 'fifo'
      'p'
    when 'file'
      '-'
    else
      ftype[0]
    end
  end

  def permissions
    mode = @stat.mode
    %i[owner group other].map do |section|
      Permission.new(mode, section)
    end
  end
end
