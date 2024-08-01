# spec/controllers/shipments_controller_spec.rb
require 'rails_helper'

RSpec.describe StoresController, type: :controller do

  let(:admin) { create(:user, email: 'myadmin@test.com', role: 'admin') }
  let(:manager) { create(:manager_user, email: 'manager@test.com',  with_store: true) }
  let(:employee) { create(:employee_user, email: 'employee@test.com',  with_store: true) }
  let(:store) { create(:store) }
  let(:shipment_attributes) { attributes_for(:shipment).merge(store_id: store.id) }
  describe 'GET #index' do

    context 'when admin is signed in' do
      before do
        sign_in admin
        get :index
      end

      it 'resturns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :index
      end

      it 'resturns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        get :index
      end

      it 'resturns a success response' do
        expect(response).to be_successful
      end
    end
  end


  describe 'GET #show' do
  let(:shipment) { create(:shipment) }

    context 'when admin is signed in' do
      before do
        sign_in admin
        get :show, params: { id: shipment.id }
      end

      it 'resturns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :show, params: { id: shipment.id }
      end

      it 'resturns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        get :show, params: { id: shipment.id }
      end

      it 'resturns a success response' do
        expect(response).to be_successful
      end
    end
  end

  #FAILURE
  describe ShipmentsController, type: :controller do

    let(:store) { create(:store) }
    let(:shipment_attributes) do
      {
        arrival_date: Date.today,
        shipment_items_attributes: [
          { quantity: 10, book_id: create(:book).id }
        ]
      }
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
    end
    #Employee CANNOT create a shipment
  end
  #POST create --only admins and managers can create a shipment
  #PUT update --only admins and managers can update a shipment
  #DELETE destroy --only admins and managers can delete a shipment



end
