# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, type: :model do
  it 'is valid with valid attributes' do
    genre = Genre.new(genre_name: 'ファンタジー')
    expect(genre).to be_valid
  end

  it 'is not valid without a genre_name' do
    genre = Genre.new(genre_name: nil)
    expect(genre).not_to be_valid
  end

  it 'is not valid with a genre_name longer than 16 characters' do
    genre = Genre.new(genre_name: 'a' * 17)
    expect(genre).not_to be_valid
  end
end
