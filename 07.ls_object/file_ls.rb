# frozen_string_literal: true

require_relative 'permission'

class FileLs < File
  def initialize(path, in_dir: false)
    super(path)
    @path = path
    @in_dir = in_dir
  end

  def mode
    [type, permissions].join
  end

  def path
    if @in_dir
      File.basename(@path)
    else
      @path
    end
  end

  def stat
    File.stat(self)
  end

  private

  def type
    ftype = File.ftype(self)
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
    mode = stat.mode
    %i[owner group other].map do |section|
      Permission.new(mode, section)
    end
  end
end
