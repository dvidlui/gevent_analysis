Rails.application.routes.draw do
  # Devise actions
  #----------------------------------------------------------------------
  devise_for :users, controllers: { 
                                    registrations:      "users/registrations", 
                                    sessions:           "users/sessions", 
                                    confirmations:      "users/confirmations", 
                                    passwords:          "users/passwords",
                                    :omniauth_callbacks => "users/omniauth_callbacks"
                                  }
  as :user do
    patch "/user/confirmation" => "confirmations#update", via: :patch, as: :update_user_confirmation
  end

  # Custom 404 errors
  #----------------------------------------------------------------------
  match "/404" => "errors#error404", via: [:get, :post, :patch, :delete]

  # root
  #----------------------------------------------------------------------
  root "home#index"

  # home pages
  #----------------------------------------------------------------------
  get "authorization"   => "home#authorization"
  get "session_expire"  => "home#session_expire"

  # DASHBOARD
  #----------------------------------------------------------------------
  get "dashboard"       => "dashboard#index"

  namespace :dashboard do
    resources :users,         except: [:show, :destroy] do     # for User
      member do
        post  :send_invite                                     # for User invitation
      end
      collection do
        get   :profile
        match :update_profile, via: [:put, :patch]
      end
    end
  end

  get "userboard"       => "userboard#index"
  namespace :userboard do
  end
end
