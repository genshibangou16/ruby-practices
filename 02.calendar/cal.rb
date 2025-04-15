#!/Users/sho.kitamura/.rbenv/shims/ruby
# frozen_string_literal: true

require 'date'

##
# 取得
##

# 今日の日付の取得
today = Date.today

# 年と月だけ抽出しておく
year = today.year
month = today.month

##
# 判定
##

# 引数のチェック
argv_year_index = ARGV.index('-y')
argv_month_index = ARGV.index('-m')

# 年、月の指定があれば今日から取得した値を上書き
unless argv_year_index.nil?
  argv_year = ARGV[argv_year_index + 1]
  if argv_year.to_s.match?(/^\d+$/) && argv_year.to_i.between?(1, 9999)
    year = argv_year
  else
    puts "cal: year '#{argv_year}' not in range 1..9999"
    exit
  end
end

unless argv_month_index.nil?
  argv_month = ARGV[argv_month_index + 1]
  if argv_month.to_s.match?(/^\d+$/) && argv_month.to_i.between?(1, 12)
    month = argv_month
  else
    puts "cal: month '#{argv_month}' not in range 1..12"
    exit
  end
end

# 「今日」に背景をつける
day = (today.day if argv_month_index.nil? && argv_year_index.nil?)

# 月初の曜日判定
beginning_of_month = Date.parse("#{year}-#{month}-1")
wday = beginning_of_month.wday
wday -= 1

# 月末の判定
last_of_month = if month.to_i == 2
                  if (year.to_i % 100).zero? && year.to_i % 400 != 0
                    28
                  elsif (year.to_i % 4).zero?
                    29
                  else
                    28
                  end
                elsif month.to_s.match?(/^(?:0?[469]|11)$/)
                  30
                else
                  31
                end

##
# 書き出し
##

# 年月の書き出し
puts "      #{month.to_s.rjust(2)}月 #{year}"

# 曜日部分の書き出し
puts '日 月 火 水 木 金 土'
# カレンダー部分の書き出し
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
