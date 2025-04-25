#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today

year = today.year
month = today.month

opt = OptionParser.new

opt.on('-m [month]', Integer) do |m|
  abort "cal: month '#{m}' not in range 1..12" unless (1..12).cover?(m)
  month = m
end

opt.on('-y [year]', Integer) do |y|
  abort "cal: year '#{y}' not in range 1..9999" unless (1..9999).cover?(y)
  year = y
end

opt.parse(ARGV)

beginning_of_month = Date.new(year, month, 1)
end_of_month = beginning_of_month.next_month.prev_day

puts "      #{month.to_s.rjust(2)}月 #{year}"
puts '日 月 火 水 木 金 土'

lines = '   ' * beginning_of_month.wday
(beginning_of_month..end_of_month).each do |date|
  lines += today == date ? format("\e[30;47m%2d\e[0m", date.day) : date.day.to_s.rjust(2)
  lines += date.saturday? ? "\n" : ' '
end

lines += "\n" unless end_of_month.saturday?

print(lines)
