Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get 'inventary', to: 'home#inventary'
  
  resources :items do
    collection {post :import}
  end
  resources :home do
    collection do
      post :check_50_last_sales
      post :get_any_items
      post :action_update_not_sale_items
      post :action_update_sale_items
      post :action_change_status_new_to_main
      post :action_create_queries_automatically_buy_item
      post :action_remove_ident_items
      post :action_update_status
    end
  end
end
