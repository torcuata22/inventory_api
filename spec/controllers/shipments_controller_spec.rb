# spec/controllers/shipments_controller_spec.rb
require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do
  let(:admin) { create(:user, email: 'myadmin@test.com', role: 'admin') }
  let(:manager) { create(:manager_user, email: 'manager@test.com', with_store: true) }
  let(:employee) { create(:employee_user, email: 'employee@test.com', with_store: true) }
  let(:store) { create(:store) }
  let(:shipment_attributes) do
    {
      arrival_date: Date.today,
      shipment_items_attributes: [
        { quantity: 10, book_id: create(:book).id }
      ],
      store_id: store.id
    }
  end

  describe 'GET #index' do
    context 'when admin is signed in' do
      before do
        sign_in admin
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    let(:shipment) { create(:shipment, store: store) }

    context 'when admin is signed in' do
      before do
        sign_in admin
        get :show, params: { id: shipment.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :show, params: { id: shipment.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        get :show, params: { id: shipment.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end
  end

  describe 'POST #create' do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'creates a new shipment' do
        expect {
          post :create, params: { store_id: store.id, shipment: shipment_attributes }
        }.to change(Shipment, :count).by(1)
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'creates a new shipment' do
        expect {
          post :create, params: { store_id: store.id, shipment: shipment_attributes }
        }.to change(Shipment, :count).by(1)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'returns forbidden status' do
        post :create, params: { store_id: store.id, shipment: shipment_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    let(:shipment) { create(:shipment, store: store) }
    let(:book) { create(:book) }
    let(:new_attributes) do
      {
        arrival_date: '2024-12-25',
        shipment_items_attributes: [
          { id: shipment.shipment_items.first.id, quantity: 5, book_id: book.id }
        ]
      }
    end

    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'updates the shipment' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        shipment.reload
        expect(shipment.arrival_date).to eq(Date.parse('2024-12-25'))
        expect(shipment.shipment_items.first.quantity).to eq(5)
      end

      it 'returns a successful response' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated shipment' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        expect(JSON.parse(response.body)['arrival_date']).to eq('2024-12-25')
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'updates the shipment' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        shipment.reload
        expect(shipment.arrival_date).to eq(Date.parse('2024-12-25'))
        expect(shipment.shipment_items.first.quantity).to eq(5)
      end

      it 'returns a successful response' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated shipment' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        expect(JSON.parse(response.body)['arrival_date']).to eq('2024-12-25')
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'returns forbidden status' do
        put :update, params: { id: shipment.id, shipment: new_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:shipment) { create(:shipment, store: store) }

    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'destroys the shipment' do
        expect {
          delete :destroy, params: { id: shipment.id }
        }.to change(Shipment, :count).by(-1)
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'destroys the shipment' do
        expect {
          delete :destroy, params: { id: shipment.id }
        }.to change(Shipment, :count).by(-1)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'returns forbidden status' do
        delete :destroy, params: { id: shipment.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
