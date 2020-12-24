Rails.application.routes.draw do
  
  get 'sessions/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
      
  # ユーザーの基本時間情報の一括更新機能
  
  get 'users/edit_time_info'
  patch 'users/update_time_info'
      
  resources :users do
    collection {post :import}
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update 
    get 'attendances/:id/edit_overtime_application', 
      to: 'attendances#edit_overtime_application', as: :attendances_edit_overtime_application
    patch 'attendances/:id/update_overtime_application', 
      to: 'attendances#update_overtime_application', as: :attendances_update_overtime_application
      get 'attendances/edit_overtime_confirmation'
  end

  
  patch 'attendances/update_overtime_confirmation'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
