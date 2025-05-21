#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DEFAULT_LENGTH = 7

def main
  params = parse_args
  target_paths = ARGV
  string_parse_results = parse_input_strings(target_paths)
  print_lines(string_parse_results, params)
  print_total(string_parse_results, params) if string_parse_results.length > 1
end

def parse_args
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| v }
  opt.on('-w') { |v| v }
  opt.on('-c') { |v| v }
  opt.parse!(ARGV, into: params)
  params.values.any? ? params : { l: true, w: true, c: true }
end

def parse_input_strings(target_paths)
  if target_paths.empty?
    [{
      path: nil,
      file_exists: true,
      is_directory: false,
      wc_data: get_wc_data($stdin.read)
    }]
  else
    target_paths.map do |path|
      file_exists = File.exist?(path)
      is_directory = File.directory?(path)
      {
        path:,
        file_exists:,
        is_directory:,
        wc_data: file_exists && !is_directory && get_wc_data(File.read(path))
      }
    end
  end
end

def get_wc_data(str)
  {
    c: str.length,
    l: str.count("\n"),
    w: str.scan(/\S+/).size
  }
end

def print_lines(string_parse_results, params)
  string_parse_results.each do |string_parse_result|
    unless string_parse_result[:file_exists]
      puts "wc: #{string_parse_result[:path]}: open: No such file or directory"
      next
    end
    if string_parse_result[:is_directory]
      puts "wc: #{string_parse_result[:path]}: read: Is a directory"
      next
    end

    print_line(string_parse_result[:wc_data], string_parse_result[:path], params)
  end
end

def print_line(wc_data, path, params)
  puts [
    '',
    *format_wc_data(wc_data, params),
    path
  ].compact.join(' ')
end

def format_wc_data(data, params)
  params.keys.map do |key|
    width = [data[key].to_s.length, DEFAULT_LENGTH].max
    data[key].to_s.rjust(width)
  end
end

def print_total(strings, params)
  total = Hash.new(0)
  strings.each do |string|
    next unless string[:wc_data]

    string[:wc_data].each { |k, v| total[k] += v.to_i }
  end
  print_line(total.filter { |_, v| v.positive? }, 'total', params)
end

main
