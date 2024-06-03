require 'rails_helper'

RSpec.describe 'Devise Routes', type: :routing do

  it 'routes /users/sign_in to users/sessions#new' do
    expect(get: 'users/sign_in').to route_to(controller: 'users/sessions', action: 'new')
  end

  it 'routes /users/sign_out to users/sessions#destroy' do
    expect(delete: '/users/sign_out').to route_to(controller: 'users/sessions', action: 'destroy')
  end

  it 'routes /users/sign_up to users/registrations#new' do
  expect(get: '/users/sign_up').to route_to(controller: 'users/registrations', action: 'new')
end

  it 'routes /users/password/new to users/passwords#new' do
    expect(get: '/users/password/new').to route_to(controller: 'users/passwords', action: 'new')
  end

end

RSpec.describe 'Users Routes', type: :routing do
  it 'routes POST /users to users#create' do
    expect(post: '/users').to route_to(controller: 'users/registrations', action: 'create')
  end
end

RSpec.describe 'Books Routes', type: :routing do
  it 'routes GET /books to books#index' do
    expect(get: 'books/').to route_to(controller: 'books', action: 'index')
  end

  it 'routes GET /books/:id to books#show' do
    expect(get: 'books/1').to route_to(controller: 'books', action: 'show', id: '1')
  end

  it 'routes PUT /books/:id to books#update' do
    expect(put: 'books/1').to route_to(controller: 'books', action: 'update', id: '1')
  end

  it 'routes POST /books/:id/undelete to books#undelete' do
    expect(post: 'books/1/undelete').to route_to(controller: 'books', action: 'undelete', id: '1')
  end

  it 'routes DELETE /books/:id/delete to books#destroy_perm' do
    expect(delete: 'books/1/destroy_perm').to route_to(controller: 'books', action: 'destroy_perm', book_id: '1')
  end

  it 'routes GET /books/deleted_books to books#deleted_books' do
    expect(delete: 'books/deleted_books').to route_to(controller:'books', action:'destroy', id: 'deleted_books')
  end

end

RSpec.describe 'Stores Routes', type: :routing do

  it 'routes GET /stores to stores#index' do
    expect(get: '/stores').to route_to(controller: 'stores', action: 'index')
  end

  it 'routes GET /stores/search_by_title to stores#search_by_title' do
    expect(get: 'stores/search_by_title').to route_to(controller: 'stores', action: 'search_by_title')
  end

  it 'routes POST /stores/:id/sales to stores#sales' do
    expect(post: 'stores/1/sales').to route_to(controller: 'stores', action: 'sales', id:'1')
  end

  it 'routes GET /stores/:id/update to store#update' do
      expect(put: 'stores/1').to route_to(controller: 'stores', action: 'update', id:'1')
  end

  it 'routes DELETE /stores/:id to store#destroy' do
    expect(delete: 'stores/1').to route_to(controller: 'stores', action: 'destroy', id: '1')
  end
end

RSpec.describe 'Store_Book Routes' do

  it 'routes GET /store_books to store_books#index' do
    expect(get: '/store_books').to route_to(controller: 'store_books', action: 'index')
  end

  it 'routes POST /store_books to store_books#create' do
    expect(post: '/store_books').to route_to(controller: 'store_books', action: 'create')
  end

  it 'routes GET /store_books/:id to store_books#show' do
    expect(get: '/store_books/1').to route_to(controller: 'store_books', action: 'show', id: '1')
  end

  it 'routes DELETE /store_books/1 to store_books#destroy' do
    expect(delete: '/store_books/1').to route_to(controller: 'store_books', action: 'destroy', id: '1')
  end

end

RSpec.describe 'Shipment Routes' do

  it 'routes GET /shipments to shipments#index' do
    expect(get: '/shipments').to route_to(controller: 'shipments', action:'index')
  end

  it 'routes GET /shipments/:id to shipments#show' do
    expect(get: '/shipments/1').to route_to(controller: 'shipments', action:'show', id: '1')
  end

  it 'routes POST /shipments to shipments#create' do
    expect(post: '/shipments').to route_to(controller: 'shipments', action:'create')
  end

  it 'routes DELETE /shipments/1 to shipments#destroy' do
    expect(delete: '/shipments/1').to route_to(controller: 'shipments', action:'destroy', id:'1')
  end

  it 'routes PUT /shipments/1 to shipments#update' do
    expect(put: '/shipments/1').to route_to(controller: 'shipments', action:'update', id:'1')
  end
end

RSpec.describe 'Shipment_Item Routes' do

  it 'routes POST /shipment_items to shipment_items#create' do
    expect(post: '/shipment_items').to route_to(controller: 'shipment_items', action: 'create')
  end

end


RSpec.describe 'Orders Routes' do

  it 'routes POST /orders/:order_id/order_items to order_items#create' do
    expect(post: 'orders/1/order_items').to route_to(controller: 'order_items', action: 'create', order_id: '1')
  end

  it 'routes DELETE /orders/:order_id/order_items/:id to order_items#destroy' do
    expect(delete: '/orders/1/order_items/1').to route_to(controller: 'order_items', action: 'destroy', order_id: '1', id: '1')
  end
end
