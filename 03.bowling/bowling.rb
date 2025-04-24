# frozen_string_literal: true

throws_str = ARGV[0]
throws = throws_str.split(',')

throw_count = 0

def calc_frame_score(throw_count, throws)
  current_throw = parse_throw(throws[throw_count])
  next_throw = parse_throw(throws[throw_count + 1])
  next_next_throw = parse_throw(throws[throw_count + 2])

  if strike?(current_throw)
    [calc_strike_score(next_throw, next_next_throw), 1]
  elsif spare?(current_throw, next_throw)
    [calc_spare_score(next_next_throw), 2]
  else
    [calc_normal_score(current_throw, next_throw), 2]
  end
end

def parse_throw(throw)
  throw == 'X' ? 10 : throw.to_i
end

def strike?(current_throw)
  current_throw == 10
end

def spare?(current_throw, next_throw)
  current_throw + next_throw == 10
end

def calc_strike_score(next_throw, next_next_throw)
  10 + next_throw + next_next_throw
end

def calc_spare_score(next_next_throw)
  10 + next_next_throw
end

def calc_normal_score(current_throw, next_throw)
  current_throw + next_throw
end

total_score = 10.times.sum do
  frame_score, throw_move_count = calc_frame_score(throw_count, throws)
  throw_count += throw_move_count
  frame_score
end

puts total_score
