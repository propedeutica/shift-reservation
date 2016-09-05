Rails.application.routes.draw do
  get 'myconfig/global_lock_enable'

  get 'myconfig/global_lock_disable'

  get 'dashboard/index'

  get 'reports/index'

  # Information for the application
  get 'info',  to: 'information#info'
  get 'help',  to: 'information#help'
  get 'about', to: 'information#about'
  # Temporary root
  root to: "information#about"
  # Resources for Rooms and Shifts
  resources :rooms do
    resources :shifts, shallow: true
  end
  get 'reports', to: "reports#index"
  get 'dashboard', to: "dashboard#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
