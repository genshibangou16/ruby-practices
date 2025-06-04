# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'CommandLineOptionsクラス' do # rubocop:disable Metrics/BlockLength
  it '-rオプションをつけると変数に格納される' do
    options = CommandLineOptions.new(['-r'])
    expect(options.all).to be_falsy
    expect(options.reverse).to be_truthy
    expect(options.long).to be_falsy
  end
  it '-aオプションをつけると変数に格納される' do
    options = CommandLineOptions.new(['-a'])
    expect(options.all).to be_truthy
    expect(options.reverse).to be_falsy
    expect(options.long).to be_falsy
  end
  it '-lオプションをつけると変数に格納される' do
    options = CommandLineOptions.new(['-l'])
    expect(options.all).to be_falsy
    expect(options.reverse).to be_falsy
    expect(options.long).to be_truthy
  end
  it '-alrオプションをつけると変数に格納される' do
    options = CommandLineOptions.new(['-lar'])
    expect(options.all).to be_truthy
    expect(options.reverse).to be_truthy
    expect(options.long).to be_truthy
  end
  it 'パスを指定すると変数に格納される' do
    options = CommandLineOptions.new(['path/to/target'])
    expect(options.all).to be_falsy
    expect(options.reverse).to be_falsy
    expect(options.long).to be_falsy
    expect(options.paths).to eq ['path/to/target']
  end
  it 'パスを複数指定すると変数に格納される' do
    options = CommandLineOptions.new(['path/to/target1', 'path/to/target2'])
    expect(options.all).to be_falsy
    expect(options.reverse).to be_falsy
    expect(options.long).to be_falsy
    expect(options.paths).to eq ['path/to/target1', 'path/to/target2']
  end
  it 'パスとオプションを同時に指定しても変数に格納される' do
    options = CommandLineOptions.new(['path/to/target1', 'path/to/target2', '-r', '-l'])
    expect(options.all).to be_falsy
    expect(options.reverse).to be_truthy
    expect(options.long).to be_truthy
    expect(options.paths).to eq ['path/to/target1', 'path/to/target2']
  end
end
