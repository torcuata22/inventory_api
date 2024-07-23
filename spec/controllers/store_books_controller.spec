require 'rails_helper'

RSpec.describe StoreBooksController, type: :controller do
  let(:admin) { create(:user, role: 'admin', email: 'thisadminemail@test.com') }
  let(:manager) { create(:user, role: 'manager', email: 'thismanager@test.com') }
  let(:employee) { create(:user, role: 'employee', email: 'thisemployee@test.com') }
  let!(:store) {create(:store)}
  let!(:book) {create(:book)}
  let!(:store_book) { create(:store_book, store: store, book: book) }

  describe "GET #index" do
    context 'when admin is signed in' do
      before do
        sign_in admin
        get :index, params: { store_id:store.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        get :index, params: { store_id:store.id }

      end

      it 'returns unauthorized response' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        get :index, params: { store_id:store.id }

      end

      it 'returns unauthorized response' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  describe 'GET #show' do

    context 'when admin is signed in' do
      before do
        sign_in admin
        get :show, params: { store_id: store.id, id: store_book.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

    end
    context 'when manager is signed in' do
      before do
        sign_in manager
        get :show, params: { store_id: store.id, id: store_book.id }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create' do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end

       #FAILS
      it 'creates a new store book' do
        expect {
          post :create, params: { store_id: store.id, store_book: { book_id: book.id } }
        }.to change(StoreBook, :count).by(1)
      end
    end


    #FAILS
    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'does not create a new store book, returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

     #FAILS
    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'does not create a new store book, returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  #destroy


end
