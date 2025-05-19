#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DEFAULT_LENGTH = 7

def main
  params = parse_args
  target_paths = ARGV
  strings_or_paths_data = parse_input_strings_or_paths(target_paths)
  print_lines(strings_or_paths_data, params)
  print_total(strings_or_paths_data, params) if strings_or_paths_data.length > 1
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

def parse_input_strings_or_paths(target_paths)
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

def print_lines(strings_or_paths_data, params)
  strings_or_paths_data.each do |string_or_path_data|
    unless string_or_path_data[:file_exists]
      puts "wc: #{string_or_path_data[:path]}: open: No such file or directory"
      next
    end
    if string_or_path_data[:is_directory]
      puts "wc: #{string_or_path_data[:path]}: read: Is a directory"
      next
    end

    print_line(string_or_path_data[:wc_data], string_or_path_data[:path], params)
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

def print_total(strings_or_paths, params)
  total = Hash.new(0)
  strings_or_paths.each do |string_or_path|
    next unless string_or_path[:wc_data]

    string_or_path[:wc_data].each { |k, v| total[k] += v.to_i }
  end
  print_line(total.filter { |_, v| v.positive? }, 'total', params)
end

main
