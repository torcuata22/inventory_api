FactoryBot.define do
  factory :user do
    email { 'admin4@testemail.com' }
    password { 'password1' }
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
    email { 'manager4@testemail.com' }
    password { 'password2' }
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
    email { 'employee4@testemail.com' }
    password { 'password3' }
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
