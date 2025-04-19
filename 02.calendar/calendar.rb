#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today

year = today.year
month = today.month
day = today.day

opt = OptionParser.new

opt.on('-m [month]') do |v|
  month = v.to_i if !v.nil?
end

opt.on('-y [year]') do |v|
  year = v.to_i if !v.nil?
end

opt.parse(ARGV)

target_day = Date.new(year, month, day)
day = today.day if today == target_day

beginning_of_month = Date.new(year, month, 1)
last_of_month = beginning_of_month.next_month.prev_day.day

wday = beginning_of_month.wday
wday -= 1

puts "      #{month.to_s.rjust(2)}月 #{year}"

puts '日 月 火 水 木 金 土'
6.times do |r|
  7.times  do |c|
    n = (r * 7) + c - wday
    if n > last_of_month
      print "\n" if c != 0
      exit
    elsif n == day
      printf("\e[30;47m%2d\e[0m", n)
    elsif n.positive?
      print n.to_s.rjust(2)
    else
      print '  '
    end
    print ' ' if c != 6
  end
  print "\n"
end
