# spec/controllers/stores_controller_spec.rb
require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  let(:admin) { create(:user, email: 'myadmin@test.com') }
  let(:manager) { create(:manager_user, email: 'manager@test.com',  with_store: true) }
  let(:employee) { create(:employee_user, email: 'employee@test.com',  with_store: true) }

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
  let(:store) { create(:store) }

  context 'when admin is signed in' do
    before do
      sign_in admin
      get :show, params: { id: store.id }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end

  context 'when manager is signed in' do
    before do
      sign_in manager
      get :show, params: { id: store.id }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end


  context 'when employee is signed in' do
    before do
      sign_in employee
      get :show, params: { id: store.id }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end


  describe 'POST #create' do
    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'creates a new store' do
        expect {
          post :create, params: { store: attributes_for(:store) }
        }.to change(Store, :count).by(1)
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
        puts manager.store_id
      end


      it 'returns a forbidden status' do
        post :create, params: { store: attributes_for(:store) }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
        puts employee.store_id
      end


      it 'returns a forbidden status' do
        post :create, params: { store: attributes_for(:store) }
        expect(response).to have_http_status(:forbidden)
      end
    end


    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'does not create a new store' do
        expect {
          post :create, params: { store: attributes_for(:store) }
        }.not_to change(Store, :count)
      end

      it 'returns a forbidden status' do
        post :create, params: { store: attributes_for(:store) }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT #update" do
  let(:store) { create(:store) }
  let(:new_attributes) { attributes_for(:store, manager: "Freya Watkins") }

    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'updates the store' do
        put :update, params: { id: store.id, store: new_attributes }
        store.reload
        expect(store.manager).to eq("Freya Watkins")
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'does not update the store' do
        put :update, params: { id: store.id, store: new_attributes }
        store.reload
        expect(store.manager).not_to eq("Freya Watkins")
      end

      it 'returns forbidden status' do
        put :update, params: { id: store.id, store: new_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'does not update the store' do
        put :update, params: { id: store.id, store: new_attributes }
        store.reload
        expect(store.manager).not_to eq("Freya Watkins")
      end

      it 'returns a forbidden status' do
        put :update, params: { id: store.id, store: new_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  describe 'DELETE #destroy' do
    let!(:store) { create(:store) }


    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'destroys the store' do
        expect {
          delete :destroy, params: { id: store.id }
        }.to change { Store.count }.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'does not destroy the store' do
        expect {
          delete :destroy, params: { id: store.id }
        }.not_to change{ Store.count }

      end

      it 'returns a forbidden status' do
        delete :destroy, params: { id: store.id }
        expect(response).to have_http_status(:forbidden)
      end

    end


    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'does not destroy the store' do
        expect {
          delete :destroy, params: { id: store.id }
        }.not_to change{ Store.count }
      end

      it 'returns a forbidden status' do
        delete :destroy, params: { id: store.id }
        expect(response).to have_http_status(:forbidden)
      end

    end
  end

  describe 'GET #inventory' do
    context 'when admin is signed in' do
    let(:admin) { create(:user, role: 'admin') }
    let(:store) { create(:store) }
    let!(:book) { create(:book, store: store, title: "Test Book") }

    before do
      # store.books << book
      sign_in admin
    end

      it "returns all inventory items for the store" do
        get :inventory, params: { id: store.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(store.books.count)
      end

      it "returns inventory items filtered by title" do
          puts "Store ID: #{store.id}, Book Title: #{book.title}, Book Store ID: #{book.store_ids}"  # Add debug information

          get :inventory, params: { id: store.id, title: book.title }
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body)
          expect(response_body).not_to be_empty
          puts "Response Body: #{response_body.inspect}"  # Add debug information

          expect(response_body.first['title']).to eq(book.title)
      end




    end
  end
  #inventory
  #sales
  #search_by_title

  end
end
