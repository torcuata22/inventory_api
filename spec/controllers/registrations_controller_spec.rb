require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe Users::RegistrationsController do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

  describe '#create' do
    context 'when current_user is not admin' do
      let(:non_admin_user) { create(:user, role: 'employee') }
      before { sign_in non_admin_user }

      it 'returns unauthorized status' do
        post :create, params: { user: attributes_for(:user, role: 'admin') }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new admin user' do
        expect {
          post :create, params: { user: attributes_for(:user, role: 'admin') }
        }.not_to change(User, :count)
      end
    end

    context 'when current user is admin' do
      let(:admin_user) { create(:user, role: 'admin') }
      before { sign_in admin_user }

      it 'creates a new admin user' do
        post :create, params: { user: attributes_for(:user, role: 'admin') }
        expect(response).to have_http_status(:created)
      end

      it 'creates a new manager user' do
        post :create, params: { user: attributes_for(:manager_user) }
        expect(response).to have_http_status(:created)
      end

      it 'creates a new employee user' do
        post :create, params: { user: attributes_for(:employee_user) }
        expect(response).to have_http_status(:created)
      end

      it 'increments user count' do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(3)
      end
    end

    context 'when current user is manager' do
      let(:manager_user) { create(:user, role: 'manager') }
      before { sign_in manager_user }

      it 'returns unauthorized status' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create any user' do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.not_to change(User, :count)
      end
    end

    context 'when current user is employee' do
      let(:employee_user) { create(:user, role: 'employee') }
      before { sign_in employee_user }

      it 'returns unauthorized status' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create any user' do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.not_to change(User, :count)
      end
    end

    context 'when invalid data is provided' do
      let(:invalid_user_data) do
        {
          email: 'example@test.com',
          password: '',
          encrypted_password: 'encrypted_password',
          reset_password_token: 'reset_password_token',
          reset_password_sent_at: '',
          remember_created_at: 'noon',
          name: 'Jane Doe',
          avatar: '',
          authentication_token: '',
          role: 'administrator in it',
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_user_data }
        }.to_not change(User, :count)
      end

      it 'returns error response' do
        post :create, params: { user: invalid_user_data }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('error') # Check for specific error message in response
      end
    end

    context 'when valid data is provided' do
      let(:valid_user_data) do
        {
          email: 'example@test.com',
          password: 'password',
          encrypted_password: 'encrypted_password',
          reset_password_token: 'reset_password_token',
          reset_password_sent_at: Time.now,
          remember_created_at: Time.now,
          name: 'Jane Doe',
          avatar: 'avatar_url',
          authentication_token: 'authentication_token',
          role: 'admin',
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_user_data }
        }.to change(User, :count).by(1)
      end

      it 'returns success response' do
        post :create, params: { user: valid_user_data }
        expect(response).to have_http_status(:created)
      end
    end
  end
end
end
