FactoryBot.define do
  factory :award do
    title { "Award" }

    trait :with_image do
      image { fixture_file_upload(Rails.root.join('spec/support/files', 'award.jpeg'), 'text/rb') }
    end
  end
end