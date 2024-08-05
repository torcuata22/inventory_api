# spec/controllers/order_items_controller_spec.rb
require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
    let(:admin) { create(:user, role: 'admin', email: 'thisadminemail@test.com') }
    let(:manager) { create(:user, role: 'manager', email: 'thismanager@test.com') }
    let(:employee) { create(:user, role: 'employee', email: 'thisemployee@test.com') }
    let!(:store) {create(:store)}
    let!(:book) {create(:book)}
    let!(:order) { create(:order) }

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
        expect(response.content_type).to eq('application/json')
      end
    end
  end

end
