# frozen_string_literal: true

FactoryBot.define do
  factory :viewed_sentence do
    association :sentence
    association :user, factory: :user
    viewed_at { Time.current }
  end
end
