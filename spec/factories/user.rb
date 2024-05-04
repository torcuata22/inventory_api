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
end
