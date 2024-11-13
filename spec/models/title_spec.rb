# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Title, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    title = build(:title, author_user: user)
    expect(title).to be_valid
  end

  it 'is not valid without an author_user_id' do
    title = build(:title, author_user: nil)
    expect(title).not_to be_valid
  end

  it 'is not valid without a main_copy' do
    title = build(:title, author_user: user, main_copy: nil)
    expect(title).not_to be_valid
  end

  it 'is not valid without is_permission_violence' do
    title = build(:title, author_user: user, is_permission_violence: nil)
    expect(title).not_to be_valid
  end

  it 'is not valid without is_permission_adult' do
    title = build(:title, author_user: user, is_permission_adult: nil)
    expect(title).not_to be_valid
  end
end
