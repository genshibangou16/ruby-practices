#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DEFAULT_LENGTH = 7

def main
  params = parse_args
  target_paths = ARGV
  inputs_info = get_inputs_info(target_paths, params)
  print_inputs_info(inputs_info)
  print_total(inputs_info) if inputs_info.length > 1
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

def get_inputs_info(target_paths, params)
  if target_paths.empty?
    [{
      path: nil,
      file_exists: true,
      is_directory: false,
      info: get_info($stdin.read, params)
    }]
  else
    target_paths.map do |path|
      file_exists = File.exist?(path)
      is_directory = File.directory?(path)
      {
        path: path,
        file_exists: file_exists,
        is_directory: is_directory,
        info: file_exists && !is_directory && get_info(File.read(path), params)
      }
    end
  end
end

def get_info(str, params)
  {
    size: params[:c] && str.length,
    lines: params[:l] && str.count("\n"),
    words: params[:w] && str.scan(/\S+/).size
  }
end

def print_inputs_info(inputs_info)
  inputs_info.each do |input_info|
    puts "wc: #{input_info[:path]}: open: No such file or directory" unless input_info[:file_exists]
    puts "wc: #{input_info[:path]}: read: Is a directory" if input_info[:is_directory]
    next if !input_info[:file_exists] || input_info[:is_directory]

    print_info(input_info[:info], input_info[:path])
  end
end

def print_info(info, path)
  puts [
    '',
    *format_info(info),
    path
  ].reject(&:nil?).join(' ')
end

def format_info(info)
  %i[lines words size].map do |key|
    next if info[key].nil?

    width = [info[key].to_s.length, DEFAULT_LENGTH].max
    info[key].to_s.rjust(width)
  end
end

def print_total(inputs_info)
  total = Hash.new(0)
  inputs_info.each do |input_info|
    next unless input_info[:info]

    input_info[:info].each { |k, v| total[k] += v.to_i }
  end
  print_info(total.filter { |_, v| v.positive? }, 'total')
end

main
