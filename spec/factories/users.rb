# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:user_id) { |n| n }
    sequence(:pen_name) { |n| "コノベル太郎#{n}" }
    sequence(:nick_name) { |n| "タロさん#{n}" }
    birth_ym { '199001' }
    agreed_terms_version { 1 }
    is_anonymous { false }
    sequence(:profile_icon_image) { |n| "icon#{n}.png" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:google_sub) { |n| "sub#{n}" }
    refresh_token { SecureRandom.hex(64) }
  end
end
