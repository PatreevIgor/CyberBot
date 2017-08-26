Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :home do
    collection do
      post :check_50_last_sales
      post :get_any_items
    end
  end
end
