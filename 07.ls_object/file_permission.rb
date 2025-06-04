# frozen_string_literal: true

class FilePermission
  SECTION = {
    owner: { shift: 2, special_char: 's' },
    group: { shift: 1, special_char: 's' },
    other: { shift: 0, special_char: 't' }
  }.freeze

  def initialize(bits, section)
    permission_bits = bits >> SECTION[section][:shift] * 3

    @readable = (permission_bits >> 2) & 1 == 1
    @writable = (permission_bits >> 1) & 1 == 1
    @executable = (permission_bits >> 0) & 1 == 1
    @special_flag = (bits >> 9 + SECTION[section][:shift]) & 1 == 1
    @special_char = SECTION[section][:special_char]
  end

  def readable?
    @readable
  end

  def writable?
    @writable
  end

  def executable?
    @executable
  end

  def to_s
    r = readable? ? 'r' : '-'
    w = writable? ? 'w' : '-'
    x = if @special_flag
          executable? ? @special_char : @special_char.upcase
        else
          executable? ? 'x' : '-'
        end
    [r, w, x].join
  end
end
