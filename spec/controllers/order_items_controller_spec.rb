# spec/controllers/order_items_controller_spec.rb
require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
    let(:admin) { create(:user, role: 'admin', email: 'thisadminemail@test.com') }
    let(:manager) { create(:user, role: 'manager', email: 'thismanager@test.com') }
    let(:employee) { create(:user, role: 'employee', email: 'thisemployee@test.com') }
    let!(:store) {create(:store)}
    let!(:book) {create(:book)}
    let!(:order) { create(:order) }
    let!(:order_item) { create(:order_item, order: order, book: book) }

    describe "GET #index" do
      context 'when admin is signed in' do
        before do
          sign_in admin
          get :index, params: { order_id: order.id, id: order_item.id }
        end

        it 'returns a success response' do
          expect(response).to be_successful
        end
      end

      context 'when manager is signed in' do
        before do
          sign_in manager
          get :index, params: { order_id: order.id, id: order_item.id }
        end

        it 'returns a forbidden response' do
          expect(response).to have_http_status(:forbidden)
        end

      end
      context 'when employee is signed in' do
        before do
          sign_in employee
          get :index, params: { order_id: order.id, id: order_item.id }
        end

        it 'returns a forbidden response' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end


    describe "GET #show" do
      context 'when admin is signed in' do
        before do
          sign_in admin
          get :show, params: { store_id: store.id, order_id: order.id, id: order_item.id }
        end

        it 'returns a success response and a JSON response' do
          expect(response).to be_successful
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'when manager is signed in' do
        before do
          sign_in manager
          get :show, params: { store_id: store.id, order_id: order.id, id: order_item.id }
        end

        it 'returns a forbidden response' do
          expect(response).to have_http_status(:forbidden)
        end
      end


      context 'when employee is signed in' do
        before do
          sign_in employee
          get :show, params: { store_id: store.id, order_id: order.id, id: order_item.id }
        end

        it 'returns a forbidden response' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe "POST #create" do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'creates a new order item' do
        store.books << book
        expect {
          post :create, params: { order_id: order.id, order_item: { book_id: book.id, quantity: 1} }
        }.to change(OrderItem, :count).by(1)
      end

      it 'renders the new order item as JSON' do
        post :create, params: { order_id: order.id, order_item: { book_id: book.id, quantity: 1} }
        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end


    context 'when manager is signed in' do
      before do
        sign_in manager
        post :create, params: { order_id: order.id, order_item: { book_id: book.id, quantity: 1} }
        store.books << book
      end

      it 'returns forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end


    context 'when employee is signed in' do
      before do
        sign_in employee
        post :create, params: { order_id: order.id, order_item: { book_id: book.id, quantity: 1} }
        store.books << book
      end

      it 'returns forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end



  end


  describe "DELETE #destroy" do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'deletes the order item' do
        expect {
          delete :destroy, params: { store_id: store.id, order_id: order.id, id: order_item.id}
        }.to change(OrderItem, :count).by(-1)

      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :show, params: { store_id: store.id, order_id: order.id, id: order_item.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end


    context 'when employee is signed in' do
      before do
        sign_in employee
        get :show, params: { store_id: store.id, order_id: order.id, id: order_item.id }
      end

      it 'returns a forbidden response' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
