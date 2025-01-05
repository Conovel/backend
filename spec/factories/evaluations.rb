# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation do
    association :sentence
    association :evaluator_user, factory: :user
    evaluation { :good }

    sequence(:sentence_id) { |n| n }
    sequence(:evaluator_user_id) { |n| n }
  end
end
