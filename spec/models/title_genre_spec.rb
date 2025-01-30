# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TitleGenre, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    title = FactoryBot.create(:title, author_user: user)
    genre = Genre.create!(genre_name: 'ファンタジー')
    title_genre = TitleGenre.new(title_id: title.id, genre_id: genre.id)
    expect(title_genre).to be_valid
  end

  it 'is not valid without a title_id' do
    title_genre = TitleGenre.new(title_id: nil, genre_id: 1)
    expect(title_genre).not_to be_valid
  end

  it 'is not valid without a genre_id' do
    title_genre = TitleGenre.new(title_id: 1, genre_id: nil)
    expect(title_genre).not_to be_valid
  end
end
