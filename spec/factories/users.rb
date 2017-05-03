# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    device
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    verified_at { Time.now }
    after(:create) do |user|
      user.device ||= Devices::Create.run!(user: resp[:user])
    end
  end
end
