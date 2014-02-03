Merlin::Application.routes.draw do
  devise_for :admins, :skip => [:sessions]

  as :admin do
    get 'admins/sign_in' => 'devise/sessions#new', :as => :new_admin_session
    post 'sessions/admin' => 'devise/sessions#create', :as => :admin_session
    delete 'admins/sign_out' => 'devise/sessions#destroy', :as => :destroy_admin_session
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root 'home#home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :tournaments

  #Home Pages
  get '/home' => 'home#home'
  get '/signup' => 'users#new'

  get '/signin' => 'sessions#new'
  delete '/signout' => 'sessions#destroy'



  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
