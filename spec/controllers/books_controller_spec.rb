# spec/controllers/books_controller_spec.rb
require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:admin) { create(:user, email: 'admin@test.com') }
  let(:manager) { create(:manager_user, email: 'manager@test.com',  with_store: true) }
  let(:employee) { create(:employee_user, email: 'employee@test.com',  with_store: true) }
  let!(:books) { create_list(:book, 3) }
  let(:book) { books.first }

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

  describe 'GET #show'
  context 'when admin is signed in' do
    before do
      sign_in admin
      get :show, params: { id: book.id }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end
  context 'when manager is signed in' do
    before do
      sign_in manager
      get :show, params: { id: book.id }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end

  context 'when employee is signed in' do
    before do
      sign_in employee
      get :show, params: { id: book.id }
    end
  end

  describe 'POST #create'
  context 'when admin is signed in' do
    before do
      sign_in admin
    end

    it 'creates a new book' do
      expect {
        post :create, params: { book: attributes_for(:book) }
      }.to change(Book, :count).by(1)
    end
  end

  context 'when manager is signed in' do
    before do
      sign_in manager
      puts manager.store_id
    end


  it 'creates book in their store' do
    expect {
      post :create, params: { book: attributes_for(:book) }
    }.to change(Book, :count).by(1)
    expect(Book.last.stores).to include(manager.store)

  end
end


  context 'when employee is signed in' do
    before do
      sign_in employee
    end

    it 'does not create a new book' do
      expect {
        post :create, params: { book: attributes_for(:book) }
      }.not_to change(Book, :count)
    end

    it 'returns a forbidden status' do
      post :create, params: { book: attributes_for(:book) }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PUT #update" do
  let(:book) { create(:book) }
  let(:new_attributes) { attributes_for(:book, title: "Updated Title") }

    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      it 'updates the book' do
        put :update, params: { id: book.id, book: new_attributes }
        book.reload
        expect(book.title).to eq("Updated Title")
      end
    end

    context 'when manager is signed in' do
      before do
        sign_in manager
      end

      it 'updates the book in their store' do
        manager.store.books << book # Assign the book to the manager's store
        put :update, params: { id: book.id, book: new_attributes }
        book.reload
        expect(book.title).to eq("Updated Title")
        expect(book.stores).to include(manager.store)
      end

      it 'does not update the book in another store' do
        other_store = create(:store)
        book.stores << other_store
        put :update, params: { id: book.id, book: new_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'does not update the book' do
        put :update, params: { id: book.id, book: new_attributes }
        book.reload
        expect(book.title).not_to eq("Updated Title")
      end

      it 'returns a forbidden status' do
        put :update, params: { id: book.id, book: new_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
  let(:book) { create(:book) }

  context 'when admin is signed in' do
    before do
      sign_in admin
    end

      it 'soft deletes the book' do
        delete :destroy, params: { id: book.id,  deletion_comment: "deletion comment" }
        # book.reload
        expect(book.reload.deleted_at).not_to be_nil
        # expect(book.deletion_comment).to eq("deletion comment")
        expect(response).to have_http_status(:ok)
      end

      it 'returns unprocessable entity if book cannot be deleted' do
        allow_any_instance_of(Book).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: book.id,  deletion_comment: "deletion comment" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq('Unable to delete book')
      end
    end

    context 'when store manager is signed in' do
      before do
        sign_in manager
        book.stores << manager.store
      end

      it 'soft deletes the book in their store' do
        delete :destroy, params: { id: book.id,  deletion_comment: "deletion comment" }
        # book.reload
        expect(book.reload.deleted_at).not_to be_nil
        # expect(book.deletion_comment).to eq("deletion comment")
        expect(response).to have_http_status(:ok)
      end

      it 'returns forbidden status if manager tries to delete book from another store' do
        other_book = create(:book)
        delete :destroy, params: { id: other_book.id, deletion_comment: 'deletion comment' }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'returns forbidden status' do
        delete :destroy, params: { id: book.id, deletion_comment: 'deletion comment' }
        expect(response).to have_http_status(:forbidden)
      end
    end


  describe 'DELETE #destroy_perm' do
      let!(:book) { create(:book) }

      # Soft delete the book (first step for permanent deletion)
      before do
        book.destroy
      end

      context 'when admin is signed in' do
        before do
          sign_in admin
          puts "Admin is signed in: #{admin.inspect}"
          # book.destroy # Soft delete the book (first step for permanent deletion)
        end

        it 'permanently deletes the book' do
          puts "TOTAL Book count before test delete: #{Book.with_deleted.count}"
          puts "With deleted Book count after test delete: #{Book.with_deleted.count}"
          #FAILURE 1
          expect {
            delete :destroy_perm, params: { id: book.id }
          }.to change { Book.with_deleted.count }.by(-1)
          expect(response).to have_http_status(:ok)
        end
      end

    context 'when manager is signed in' do
      before do
        sign_in manager
        book.stores << manager.store
        # manager.store.books << book #associate book with manager's store here
        # book.destroy
      end
      #FAILURE 2
      it 'permanently deletes the book in their store' do
        puts "Total Book count before test delete: #{Book.unscoped.count}"
        puts "With deleted Book count before test delete: #{Book.with_deleted.count}"
        expect {
          delete :destroy_perm, params: { id: book.id }
      }.to change { Book.with_deleted.count }.by(-1)
      expect(response).to have_http_status(:ok)
      end

      it 'returns forbidden status if manager tries to permanently delete a book not in their store' do
        other_book = create(:book)
        other_book.destroy
        delete :destroy_perm, params: { id: other_book.id  }
        expect(response).to have_http_status(:forbidden)
      #   expect {
      #     delete :destroy_perm, params: { id: other_book.id }
      # }.not_to change{ Book.with_deleted.count }
      # expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

        it 'returns forbidden status' do
          expect {
            delete :destroy_perm, params: { id: book.id }
        }.not_to change{ Book.with_deleted.count }
        expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
