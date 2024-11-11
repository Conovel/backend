# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(
      pen_name: 'コノベル太郎',
      nick_name: 'タロさん',
      birth_ym: '199001',
      agreed_terms_version: 1,
      is_anonymous: false,
      profile_icon_image: 'icon1.png',
      email: 'user_test@example.com',
      google_sub: 'sub_test'
    )
    expect(user).to be_valid
  end

  it 'is not valid without a pen_name' do
    user = User.new(
      nick_name: 'タロさん',
      birth_ym: '199001',
      agreed_terms_version: 1,
      is_anonymous: false,
      profile_icon_image: 'icon1.png',
      email: 'user_test@example.com',
      google_sub: 'sub_test'
    )
    expect(user).not_to be_valid
  end
end
