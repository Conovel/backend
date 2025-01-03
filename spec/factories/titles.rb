# frozen_string_literal: true

FactoryBot.define do
  factory :title do
    sequence(:title_id) { |n| n }
    association :author_user, factory: :user
    sequence(:title) { |n| "テスト投稿タイトル#{n}" }
    is_permission_violence { false }
    is_permission_adult { false }
    main_copy { 'キャッチコピーキャッチコピー' }
    overview { '説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明' }
  end
end
