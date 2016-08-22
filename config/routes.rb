Rails.application.routes.draw do
  # Information for the application
  get 'information/info'
  get 'information/help'
  get 'information/about'
  # Temporary root
  root to: "information#about"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
