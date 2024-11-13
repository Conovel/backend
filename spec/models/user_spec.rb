# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is not valid without a pen_name' do
    user = build(:user, pen_name: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a nick_name' do
    user = build(:user, nick_name: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a google_sub' do
    user = build(:user, google_sub: nil)
    expect(user).not_to be_valid
  end
end
