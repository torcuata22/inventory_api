Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create]
  resources :books do
    member do
      post 'undelete'
    end
    delete 'destroy_perm'
    collection do
      get 'deleted_books'
    end
  end

  resources :stores do
    collection do
      get 'search_by_title'
    end
    member do
      post 'sales'
    end
  end
  resources :store_books, only: [:create]
  resources :shipments
  resources :shipment_items
  resources :orders do
    resources :order_items, only: [:create, :destroy]
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
