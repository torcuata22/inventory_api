FactoryBot.define do
  factory :user do
    email { 'example@test.com' }
    password { 'password' }
    encrypted_password { 'encrypted_password' }
    reset_password_token { 'reset_password_token' }
    reset_password_sent_at { -> { Time.now } }  # Use a lambda or block for dynamic timestamp
    remember_created_at { -> { Time.now } }     # Use a lambda or block for dynamic timestamp
    name { 'Jane Doe' }
    avatar { 'avatar_url' }
    authentication_token { 'authentication_token' }
    role { 'admin' }
  end

  factory :manager_user, class: 'User' do
    email { 'manager@test.com' }
    password { 'password' }
    encrypted_password { 'encrypted_password' }
    reset_password_token { 'reset_password_token' }
    reset_password_sent_at { -> { Time.now } }  # Use a lambda or block for dynamic timestamp
    remember_created_at { -> { Time.now } }     # Use a lambda or block for dynamic timestamp
    name { 'Zoey Doe' }
    avatar { 'avatar_url' }
    authentication_token { 'authentication_token' }
    role { 'manager' }
  end

  factory :employee_user, class: 'User' do
    email { 'employee@test.com' }
    password { 'password' }
    encrypted_password { 'encrypted_password' }
    reset_password_token { 'reset_password_token' }
    reset_password_sent_at { -> { Time.now } }  # Use a lambda or block for dynamic timestamp
    remember_created_at { -> { Time.now } }     # Use a lambda or block for dynamic timestamp
    name { 'Joey Doe' }
    avatar { 'avatar_url' }
    authentication_token { 'authentication_token' }
    role { 'employee' }
  end
end
