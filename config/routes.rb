CaptureDashboard::Application.routes.draw do
  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  namespace :dashboard do
    get "index"
    get "airbrake"
    get "health_check"
    get "resque"
  end
  get "/capture_dashboard/health" => "health_check#health", :as => "health"
end
