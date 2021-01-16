# frozen_string_literal: true
FactoryBot.define do
  sequence :body do |b|
    "Answer body - #{b}"
  end
  factory :answer do
    body
    question { nil }
    user

    trait :invalid do
      body { nil }
    end
  end
end
