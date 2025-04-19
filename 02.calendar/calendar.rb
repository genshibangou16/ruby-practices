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
last_of_month = beginning_of_month.next_month.prev_day.day

wday = beginning_of_month.wday

puts "      #{month.to_s.rjust(2)}月 #{year}"
puts '日 月 火 水 木 金 土'

6.times do |row|
  7.times  do |col|
    day = (row * 7) + col - wday + 1
    if day > last_of_month
      print "\n" if col != 0
      exit
    elsif day.positive?
      if Date.new(year, month, day) == today
        printf("\e[30;47m%2d\e[0m", day)
      else
        print day.to_s.rjust(2)
      end
    else
      print '  '
    end
    print ' ' if col != 6
  end
  print "\n"
end
