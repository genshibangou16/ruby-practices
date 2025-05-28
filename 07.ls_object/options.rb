# frozen_string_literal: true

require 'optparse'

class Options
  attr_reader :all, :reverse, :long, :paths

  def initialize(args)
    @all = false
    @reverse = false
    @long = false
    parse(args)
  end

  private

  def parse(args)
    opt = OptionParser.new
    opt.on('-a') { @all = true }
    opt.on('-r') { @reverse = true }
    opt.on('-l') { @long = true }
    opt.parse!(args)
    @paths = args.empty? ? ['.'] : args
  end
end
