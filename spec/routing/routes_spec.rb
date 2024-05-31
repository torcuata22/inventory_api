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

end
