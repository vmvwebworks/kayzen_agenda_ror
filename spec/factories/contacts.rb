FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Contact #{n}" }
    phone { "1234567890" }
    email { "contact@example.com" }
  end
end