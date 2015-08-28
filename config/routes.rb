Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'filebox#index'
  get 'filebox' => 'filebox#index'
  get 'login' => 'filebox#login'
  
  get 'filebox/:folder_id/item/:item_id/show_image' => 'filebox#show_image', as: 'show_image'
  
  get 'filebox/:folder_id/item/:item_id/download' => 'filebox#download_file', as: 'download_file'

  delete 'filebox/:folder_id/item/:item_id/delete_item' => 'filebox#delete_item', as: 'delete_item'
  
  get 'filebox/:folder_id/get_folders_and_items' => 'filebox#get_folders_and_items'

  resources :filebox do
    post 'create_file' => 'filebox#create_file'
  end

  resources :folder
  resources :item

  namespace :api do
    resources :api, path: '', except: [:show, :edit, :update, :new, :update, :destroy]
    resources :folder
    resources :item
  end
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
