# spec/controllers/books_controller_spec.rb
require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:admin) { create(:user, email: 'myadmin@test.com') }
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
      puts "CREATING NEW BOOK AS ADMIN"
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

  describe 'PUT #soft_destroy' do #NEED to change to soft_desrtoy
  # let(:book) { create(:book) }

  context 'when admin is signed in' do
    let(:admin) { create(:user, role: 'admin') }
    let(:book) { create(:book) }
  end
    before do
      sign_in admin
    end

      it 'soft deletes the book' do
        expect{
          delete :soft_destroy, params: { id: book.id, deletion_comment: 'Soft delete comment' }
      }.to change { Book.not_deleted.count }.by(-1)

        expect(response).to have_http_status(:ok)
      end

      it 'returns unprocessable entity if book cannot be deleted' do
        allow_any_instance_of(Book).to receive(:update).and_return(false)
        delete :soft_destroy, params: { id: book.id,  deletion_comment: "soft delete comment" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq('Unable to delete the book')
      end
    end

    context 'when store manager is signed in' do

      before do
        sign_in manager
        book.stores << manager.store
      end

      it 'soft deletes the book in their store' do
        expect {
          put :soft_destroy, params: { id: book.id, deletion_comment: 'soft delete comment' }
        }.to change { book.reload.deleted_at }.from(nil).to(be_within(1.second).of(Time.current))
        expect(response).to have_http_status(:ok)
      end

      it 'returns forbidden status if manager tries to delete book from another store' do
        other_store = create(:store)
        other_book = create(:book, stores: [other_store])
        put :soft_destroy, params: { id: other_book.id, deletion_comment: 'Soft delete comment' }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when employee is signed in' do
      before do
        sign_in employee
      end

      it 'returns forbidden status' do
        put :soft_destroy, params: { id: book.id, deletion_comment: 'deletion comment' }
        expect(response).to have_http_status(:forbidden)
      end
    end


  describe 'DELETE #destroy_perm' do
      let(:book) { create(:book) }
      before do
        book.soft_delete
        book.reload
        puts " SOFT DELETION TIME: #{book.deleted_at}"
      end

      context 'when admin is signed in' do
        let(:admin) { create(:user, role: 'admin', email: 'theadmin@email.com') }
        let(:book) { create(:book) }
        before do
          sign_in admin
        end

        it 'permanently deletes the book' do
          expect {
            delete :destroy_perm, params: { id: book.id }
          }.to change { Book.deleted.count }.by(-1)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when manager is signed in' do
        let(:store) { create(:store) }
        let(:manager_user) { create(:user, email: 'store_manager@email.com', role: 'manager', store: store) }
        let(:book) { create(:book, stores: [store], store_id: store.id) }

        before do
          sign_in manager_user
          store.books << book
          book.soft_delete
          book.reload
          puts "Manager store: #{manager_user.store.id}"
          puts "Book: #{book.inspect}"
          puts "Book store: #{book.stores.map(&:id)} before soft delete"
          puts "Book store: #{book.stores.map(&:id)} after soft delete"
          puts "Book soft deleted: #{book.deleted_at.present?} and Deletion comment: #{book.deletion_comment.present?}"
        end

        it 'permanently deletes the book in their store' do
          puts "Before destroy_perm - Deleted books count: #{Book.deleted.count}"
          expect {
            delete :destroy_perm, params: { id: book.id }
            puts "Controller action completed"
            puts "Book destroyed: #{book.destroyed?}"
            puts "After destroy_perm - Deleted books count: #{Book.deleted.count}"
          }.to change { Book.deleted.count }.by(-1)
          expect(response).to have_http_status(:ok)



      end


        it 'returns forbidden status if manager tries to permanently delete a book not in their store' do
          other_store = create(:store)
          other_book = create(:book, stores: [other_store])
          other_book.soft_delete
          other_book.reload
          delete :destroy_perm, params: { id: other_book.id }
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when employee is signed in' do
        before do
          sign_in employee
        end

        it 'returns forbidden status' do
          expect {
            delete :destroy_perm, params: { id: book.id }
          }.not_to change{ Book.deleted.count }
          expect(response).to have_http_status(:forbidden)
        end
      end

    end
  end
