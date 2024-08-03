# spec/controllers/orders_controller_spec.rb
require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:admin) { create(:user, email: 'admin@test.com', role: 'admin') }
  let(:manager) { create(:manager_user, email: 'themanager@test.com',  with_store: true) }
  let(:employee) { create(:employee_user, email: 'myemployee@test.com',  with_store: true) }
  let(:store) { create(:store) }
  let(:order_attributes) do
    {
      name: "Bilbo Baggins",
      address: "The Grey Haven",
      total_price: 100.0,
      store_id: store.id,
      user_id: admin.id
    }
  end

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

  describe 'POST #create' do

    context 'when admin is signed in' do
      before do
        sign_in admin
        @order = create(:order)
      end
      it 'returns a success response' do
        post :create, params: { store_id: store.id, order: order_attributes }
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        @order = create(:order)
      end
      it 'returns a success response' do
        post :create, params: { store_id: store.id, order: order_attributes }
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        @order = create(:order)
      end
      it 'returns a success response' do
        post :create, params: { store_id: store.id, order: order_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    let(:order) { create(:order, store: store) }
    let(:new_attributes) do
      {
        name: "Frodo Baggins",
        address: "The Grey Haven",
        total_price: 150.0,
        store_id: store.id,
        user_id: admin.id
      }
    end
    context 'when admin is signed in' do
      before do
        sign_in admin
      end
      it 'updates the order' do
        put :update, params: { id: order.id, order: new_attributes }
        order.reload
        expect(order.name).to eq("Frodo Baggins")
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end
      it 'updates the order' do
        put :update, params: { id: order.id, order: new_attributes }
        order.reload
        expect(order.name).to eq("Frodo Baggins")
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end
      it 'updates the order' do
        put :update, params: { id: order.id, order: new_attributes }
        order.reload
        expect(order.name).to eq("Frodo Baggins")
      end
    end
  end


  describe 'DELETE #destroy' do

    context 'when admin is signed in' do
      before do
        sign_in admin
      end
      it 'destroys the order' do
        order = create(:order, store: store)
        expect {
          delete :destroy, params: { id: order.id }
        }.to change(Order, :count).by(-1)
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end
      it 'destroys the order' do
        order = create(:order, store: store)
        expect {
          delete :destroy, params: { id: order.id }
        }.to change(Order, :count).by(-1)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end
      it 'destroys the order' do
        order = create(:order, store: store)
        expect {
          delete :destroy, params: { id: order.id }
        }.to change(Order, :count).by(-1)
      end
    end
  end
end
