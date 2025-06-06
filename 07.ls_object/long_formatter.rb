# frozen_string_literal: true

require_relative 'formatter'

class LongFormatter < Formatter
  private

  def format(files)
    max_lengths = {
      nlink: files.map { |file| file.nlink.to_s.length }.max,
      size: files.map { |file| file.size.to_s.length }.max,
      uid: files.map { |file| file.uid.length }.max,
      gid: files.map { |file| file.gid.length }.max
    }
    files.each do |file|
      @lines.push [
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

  def total_blocks(directory)
    @lines.push "total #{directory.blocks}"
  end
end
