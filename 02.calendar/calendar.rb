#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today

year = today.year
month = today.month

opt = OptionParser.new

opt.on('-m [month]') do |v|
  month = v.to_i if !v.nil?
end

opt.on('-y [year]') do |v|
  year = v.to_i if !v.nil?
end

opt.parse(ARGV)

beginning_of_month = Date.new(year, month, 1)
end_of_month = beginning_of_month.next_month.prev_day

puts "      #{month.to_s.rjust(2)}月 #{year}"
puts '日 月 火 水 木 金 土'

lines = "   " * beginning_of_month.wday
(beginning_of_month..end_of_month).each do |date|
  if today == date
    lines += "\e[30;47m#{date.day}\e[0m"
  else
    lines += date.day.to_s.rjust(2)
  end

  if date.saturday?
    lines += "\n"
  else
    lines += ' '
  end
end

lines += "\n" if !end_of_month.saturday?

print(lines)
