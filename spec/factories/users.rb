FactoryBot.define do

  sequence :email do |i|
    "user#{i}@email.ru"
  end

  factory :user do
    email
    password {"test123"}
    password_confirmation {"test123"}
  end
end
