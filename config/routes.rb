Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get 'inventary', to: 'home#inventary'

  resources :home do
    collection do
      post :check_50_last_sales
      post :get_any_items
      post :action_update_not_sale_items
      post :action_update_sale_items
      post :action_change_status_new_to_main
    end
  end
end
