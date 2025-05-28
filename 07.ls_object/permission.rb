# frozen_string_literal: true

class Permission
  SECTION = {
    owner: { shift: 2, special_char: 's' },
    group: { shift: 1, special_char: 's' },
    other: { shift: 0, special_char: 't' }
  }.freeze

  def initialize(bits, section)
    permission_bits = bits >> SECTION[section][:shift] * 3

    @r        = (permission_bits >> 2) & 1 == 1 ? 'r' : '-'
    @w        = (permission_bits >> 1) & 1 == 1 ? 'w' : '-'
    exec_flag = (permission_bits >> 0) & 1 == 1

    special_flag = (bits >> 9 + SECTION[section][:shift]) & 1 == 1
    @x = if special_flag
           exec_flag ? SECTION[section][:special_char] : SECTION[section][:special_char].upcase
         else
           exec_flag ? 'x' : '-'
         end
  end

  def to_s
    [@r, @w, @x].join
  end
end
