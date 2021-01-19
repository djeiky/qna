# frozen_string_literal: true
FactoryBot.define do
  sequence :title do |t|
    "Question title - #{t}"
  end

  factory :question do
    title
    body { 'MyText' }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb')}
    end
  end
end
