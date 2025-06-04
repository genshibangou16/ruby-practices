# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'FileLsクラス' do
  before do
    @gemfile = FileLs.new('Gemfile')
    @readme = FileLs.new('README.md')
  end
  it 'パスを持つ' do
    expect(@gemfile.path).to eq 'Gemfile'
  end
  it '対応するファイル/ディレクトリのFile::Statを取得できる' do
    expect(@gemfile.stat.class).to eq File::Stat
  end
  it 'パーミッションが確認できる' do
    expect(@readme.mode).to eq '-rw-r--r--'
    expect(@gemfile.mode).to eq '-rw-r--r-T'
  end
end
