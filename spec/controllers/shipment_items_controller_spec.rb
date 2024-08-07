require 'rails_helper'

RSpec.describe ShipmentItemsController, type: :controller do
    let(:admin) { create(:user, role: 'admin', email: 'thisadminemail@test.com') }
    let(:manager) { create(:user, role: 'manager', email: 'thismanager@test.com') }
    let(:employee) { create(:user, role: 'employee', email: 'thisemployee@test.com') }
    let!(:store) {create(:store)}
    let!(:book) {create(:book)}
    let!(:order) { create(:order) }
    let! (:shipment) { create(:shipment) }
    let! (:shipment_item) { create(:shipment_item, shipment: shipment) }
    let(:shipment_item_attributes) { { book_id: book.id, quantity: 35 } }

  describe 'GET #index ' do
    context 'when admin is signed in' do
      before do
        sign_in admin
        get :index, params: { shipment_id: shipment.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :index, params: { shipment_id: shipment.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        get :index, params: { shipment_id: shipment.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #show' do
    context 'when admin is signed in' do
      before do
        sign_in admin
        get :show, params: { shipment_id: shipment.id, id: shipment_item.id }
      end

      it 'returns a success response and a JSON response' do
        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when manager is signed_in' do
      before do
        sign_in manager
        get :show, params: { shipment_id: shipment.id, id: shipment_item.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed_in' do
      before do
        sign_in employee
        get :show, params: { shipment_id: shipment.id, id: shipment_item.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create' do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end
      it 'creates a new shipment_item' do
        expect {
          post :create, params: { shipment_id: shipment.id, shipment_item: shipment_item_attributes }
        }.to change(ShipmentItem, :count).by(1)
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        post :create, params: { shipment_id: shipment.id, shipment_item: shipment_item_attributes }
      end
      it 'returns forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end


    context 'when employee is signed in' do
      before do
        sign_in employee
        post :create, params: { shipment_id: shipment.id, shipment_item: shipment_item_attributes }
      end
      it 'returns forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it "destroys the shipment_item" do
        expect {
          delete :destroy, params: { shipment_id: shipment.id, id: shipment_item.id }
        }.to change(ShipmentItem, :count).by(-1)

      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        delete :destroy, params: { shipment_id: shipment.id, id: shipment_item.id }

      end

      it "does not destroy the shipment_item, returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        delete :destroy, params: { shipment_id: shipment.id, id: shipment_item.id }

      end

      it "does not destroy the shipment_item, returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end




  end
end
