# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Title, type: :model do
  let(:user) { User.find_by(email: 'user1@example.com') }

  it 'is valid with valid attributes' do
    title = Title.new(
      author_user_id: user.id,
      title: '吾輩は猫である',
      is_permission_violence: false,
      is_permission_adult: false,
      main_copy: '吾輩の大冒険'
    )
    expect(title).to be_valid
  end

  it 'is not valid without an author_user_id' do
    title = Title.new(
      title: '吾輩は猫である',
      is_permission_violence: false,
      is_permission_adult: false,
      main_copy: '吾輩の大冒険'
    )
    expect(title).not_to be_valid
  end

  it 'is not valid without a main_copy' do
    title = Title.new(
      author_user_id: user.id,
      title: '吾輩は猫である',
      is_permission_violence: false,
      is_permission_adult: false
    )
    expect(title).not_to be_valid
  end

  it 'is not valid without is_permission_violence' do
    title = Title.new(
      author_user_id: user.id,
      title: '吾輩は猫である',
      is_permission_adult: false,
      main_copy: '吾輩の大冒険'
    )
    expect(title).not_to be_valid
  end

  it 'is not valid without is_permission_adult' do
    title = Title.new(
      author_user_id: user.id,
      title: '吾輩は猫である',
      is_permission_violence: false,
      main_copy: '吾輩の大冒険'
    )
    expect(title).not_to be_valid
  end
end
# rubocop:enable Metrics/BlockLength
