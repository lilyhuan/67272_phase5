Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :employees
  resources :stores
  resources :assignments

  resources :shifts
  resources :pay_grades
  resources :pay_grade_rates
  resources :jobs
  resources :shift_jobs

  # Authorizations
  resources :sessions
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  # Custom routes
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment
  patch 'home/:id/clock_in', to: 'home#clock_in', as: :clock_in
  patch 'home/:id/clock_out', to: 'home#clock_out', as: :clock_out

  # You can have the root of your site routed with 'root'
  root 'home#index'
end
