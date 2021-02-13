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

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb') }
    end

    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end
