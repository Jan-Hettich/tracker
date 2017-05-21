Rails.application.routes.draw do
  crud = %i(index show create update destroy)

  namespace :v1 do
    resources :projects, only: crud do
    	resources :tasks, only: %i(index create)
    end
    resources :tasks, only: %i(show update destroy)
  end
end
