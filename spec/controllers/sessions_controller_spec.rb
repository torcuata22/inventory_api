require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:admin_user) { create(:user) }
  let(:manager_user) { create(:manager_user) }
  let(:employee_user) { create(:employee_user) }

  describe "POST #create" do
    context "with valid credentials" do
      it "returns a success response with user data and token for admin user" do
        post :create, params: { user: { email: admin_user.email, password: 'password1' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("user", "token")
      end

      it "returns a success response with user data and token for manager user" do
        post :create, params: { user: { email: manager_user.email, password: 'password2' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("user", "token")
      end

      it "returns a success response with user data and token for employee user" do
        post :create, params: { user: { email: employee_user.email, password: 'password3' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("user", "token")
      end
    end

    context "with invalid credentials" do
      it "returns an error response" do
        post :create, params: { user: { email: admin_user.email, password: "wrong_password" } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before { sign_in admin_user }

      it "logs out the user" do
        delete :destroy
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when no user is logged in" do
      it "returns an error response" do
        # Ensure there is no signed-in user by stubbing the current_user method
        allow(controller).to receive(:current_user).and_return(nil)

        # Send the DELETE request to the destroy action, the error is HERE, in this line:
        delete :destroy

        # Check that the response status is :unauthorized
        expect(response).to have_http_status(:unauthorized)
      end
    end

    # context "when no user is logged in" do
    #   puts "will it run?"
    #   it "returns an error response" do
    #     puts"starting test"
    #     delete :destroy
    #     puts "RESPONSE: #{response.inspect}"
    #     expect(response).to have_http_status(:unauthorized)
    #   end
    # end
  end
end
