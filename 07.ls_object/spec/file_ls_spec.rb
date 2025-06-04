# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'FileEntryクラス' do # rubocop:disable Metrics/BlockLength
  before do
    @gitkeep = FileEntry.new('.gitkeep')
    @ls_rb = FileEntry.new('ls.rb')
  end
  it 'パスを持つ' do
    expect(@gitkeep.path).to eq '.gitkeep'
  end
  it '対応するファイル/ディレクトリのuidを取得できる' do
    expect(@gitkeep.uid).to eq Etc.getpwuid(File.stat('.gitkeep').uid).name
  end
  it '対応するファイル/ディレクトリのgidを取得できる' do
    expect(@gitkeep.gid).to eq 'staff'
  end
  it '対応するファイル/ディレクトリのnlinkを取得できる' do
    expect(@gitkeep.nlink).to eq 1
  end
  it '対応するファイル/ディレクトリのsizeを取得できる' do
    expect(@gitkeep.size).to eq 0
  end
  it '対応するファイル/ディレクトリのmtimeを取得できる' do
    expect(@gitkeep.mtime).to eq File.stat('.gitkeep').mtime
  end
  it '対応するファイル/ディレクトリのsymlink?を取得できる' do
    expect(@gitkeep.symlink?).to be_falsy
  end
  it '対応するファイル/ディレクトリのblocksを取得できる' do
    expect(@gitkeep.blocks).to eq 0
  end
  it 'パーミッションが確認できる' do
    expect(@ls_rb.mode).to eq '-rwxr-xr-x'
    expect(@gitkeep.mode).to eq '-rw-r--r--'
  end
end
