# frozen_string_literal: true

FactoryBot.define do
  factory :sentence do
    association :user, factory: :user
    sequence(:sentence) { |n| "テストテスト#{n}" }
    parent_sentence_id { nil }
    association :title
    sentence_hierarchy { 1 }

    trait :with_specific_content do
      transient do
        content { 'あああああ' }
        parent_sentence { nil }
        hierarchy { 1 }
      end

      sentence { content }
      parent_sentence_id { parent_sentence&.sentence_id }
      sentence_hierarchy { hierarchy }
    end
  end
end
