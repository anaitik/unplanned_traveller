Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post '/shortest_path', to: 'routes#shortest_path'
  post '/shortest_path_routes', to: 'port_routes#shortest_path'
  get '/estimate_timings', to: 'estimate_timings_destinations#estimated_time'
end

