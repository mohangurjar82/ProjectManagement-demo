Rails.application.routes.draw do
  namespace :api do
    post 'auth/signup', to: 'auth#signup'
    post 'auth/login', to: 'auth#login'
    namespace :v1 do
      resources :users, only: [:index, :show] do
        member do
          get :projects
        end
      end

      resources :projects, only: [:index, :show] do
        collection do
          get :active
        end
        member do
          get :task_breakdown
        end
        resources :tasks, only: [:create, :index]
      end

      resources :tasks, only: [:create, :show]

      post 'assign_user', to: 'projects#assign_user'
    end
  end
end
