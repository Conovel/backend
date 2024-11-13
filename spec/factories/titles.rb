# frozen_string_literal: true

FactoryBot.define do
  factory :title do
    association :author_user, factory: :user
    sequence(:title) { |n| "吾輩は猫である#{n}" }
    is_permission_violence { false }
    is_permission_adult { false }
    main_copy { '吾輩の大冒険' }
    overview { '吾輩の大冒険は始まったばかり！大スペクタクル冒険活劇！全米が泣いた！！' }
  end
end
