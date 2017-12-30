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
      post :button_get_any_items
      post :button_update_sale_items
      post :button_change_status_new_to_main
      post :button_re_create_buy_orders
      post :button_remove_ident_items
      post :button_update_status
      post :button_update_price_bought_items
    end
  end
end
