# spec/controllers/orders_controller_spec.rb
require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:admin) { create(:user, email: 'admin@test.com', role: 'admin') }
  let(:manager) { create(:manager_user, email: 'themanager@test.com',  with_store: true) }
  let(:employee) { create(:employee_user, email: 'myemployee@test.com',  with_store: true) }
  let(:store) { create(:store) }

  describe 'GET #index' do

    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do

    context 'when admin is signed in' do
      before do
        sign_in admin
        @order = create(:order)
      end
      it 'returns a success response' do
        get :show, params: { id: @order.id }
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        @order = create(:order)
      end
      it 'returns a success response' do
        get :show, params: { id: @order.id }
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        @order = create(:order)
      end
      it 'returns a success response' do
        get :show, params: { id: @order.id }
        expect(response).to be_successful
      end
    end
  end


#create (POST)
#update (PUT)
#destroy (DELETE)

end
