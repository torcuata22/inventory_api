FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "admin#{n}@testemail.com" }
    password { 'password1' }
    reset_password_token { SecureRandom.urlsafe_base64 }
    reset_password_sent_at { -> { Time.now } }  # Use a lambda or block for dynamic timestamp
    remember_created_at { -> { Time.now } }     # Use a lambda or block for dynamic timestamp
    name { 'Jane Doe' }
    avatar { 'avatar_url' }
    authentication_token { 'authentication_token' }
    role { 'admin' }
  end

  factory :manager_user, class: 'User' do
    sequence(:email) { |n| "manager#{n}@testemail.com" }
    password { 'password2' }
    reset_password_token { SecureRandom.urlsafe_base64 }
    reset_password_sent_at { -> { Time.now } }  # Use a lambda or block for dynamic timestamp
    remember_created_at { -> { Time.now } }     # Use a lambda or block for dynamic timestamp
    name { 'Zoey Doe' }
    avatar { 'avatar_url' }
    authentication_token { 'authentication_token' }
    role { 'manager' }
    # Conditionally include the association with store
    transient do
      with_store { true }
    end

    after(:build) do |user, evaluator|
      user.store = create(:store) if evaluator.with_store
    end
  end

  factory :employee_user, class: 'User' do
    sequence(:email) { |n| "employee#{n}@testemail.com" }
    password { 'password3' }
    reset_password_token { SecureRandom.urlsafe_base64 }
    reset_password_sent_at { -> { Time.now } }  # Use a lambda or block for dynamic timestamp
    remember_created_at { -> { Time.now } }     # Use a lambda or block for dynamic timestamp
    name { 'Joey Doe' }
    avatar { 'avatar_url' }
    authentication_token { 'authentication_token' }
    role { 'employee' }
  # Conditionally include the association with store
    transient do
      with_store { true }
    end

    after(:build) do |user, evaluator|
      user.store = create(:store) if evaluator.with_store
    end
  end
end
