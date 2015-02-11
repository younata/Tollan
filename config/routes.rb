Rails.application.routes.draw do
  get 'login', to: 'session#new'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'

  get 'bulbs', to: 'bulb#index'
  get 'bulbs/:id', to: 'bulb#view'
  put 'bulbs/:id', to: 'bulb#update'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'bulbs/groups', to: 'group#index'
      get 'bulbs/groups/:id', to: 'group#show'

      #post 'bulbs/groups', to: 'group#create'
      #put 'bulbs/groups/:id', to: 'group#update'
      #delete 'bulbs/groups/:id', to 'group#delete'

      get 'bulbs', to: 'bulb#index'
      get 'bulbs/:id', to: 'bulb#show'

      put 'bulbs/:id', to: 'bulb#update'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'main#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
