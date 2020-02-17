Rails.application.routes.draw do
  root to: 'home#show'

  namespace :api, module: :api do
    namespace :v1, module: :v1 do
      resources :github_repository_searches, only: :create
    end
  end
end
