# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Permissionクラス' do
  it 'rw-' do
    p = Permission.new(0o100644, :owner)
    expect(p.to_s).to eq 'rw-'
  end
  it 'r--' do
    p = Permission.new(0o100644, :group)
    expect(p.to_s).to eq 'r--'
  end
  it 'r--' do
    p = Permission.new(0o100644, :other)
    expect(p.to_s).to eq 'r--'
  end
  it 'rwS' do
    p = Permission.new(0o104644, :owner)
    expect(p.to_s).to eq 'rwS'
  end
  it 'rwt' do
    p = Permission.new(0o101007, :other)
    expect(p.to_s).to eq 'rwt'
  end
end
