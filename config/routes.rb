Att::Application.routes.draw do
  resources :punches

  resources :slips

  resources :payrolls do 
    resources :employees
    member do
     get 'get_employee_hours'
    end
  end

  resources :employees do
    member do
     get 'set_current'
    end
  end
  
  resources :stores do
    member do
     get 'set_current'
    end
  end

  resources :posts do
    resources :comments
  end

  scope :api do
    get "/payrolls(.:format)" => "payrolls#index"
    get "/payrolls/:id(.:format)" => "payrolls#show"
    post "/payrolls(.:format)" => "payrolls#create"
		put "/payrolls/:id(.:format)" => "payrolls#update"
    delete "/payrolls/:id(.:format)" => "payrolls#destroy"

    get "/slips(.:format)" => "slips#index"
    get "/slips/:id(.:format)" => "slips#show"

    get "/employees(.:format)" => "employees#index"
    get "/employees/:id(.:format)" => "employees#show"
  end

  root 'stores#index'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
