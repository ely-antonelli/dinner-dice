Rails.application.routes.draw do
  devise_for :users
  get "kitchen", to: "kitchens#show"
  get "my_kitchen", to: "kitchens#show"
  get 'my_fridge', to: 'fridges#show', as: 'my_fridge'
  get "random_recipe", to: "recipes#random_recipe"

  # get 'my_recipes', to: 'recipes#my_recipes'
  # get 'my_recipes/:id', to: 'recipes#my_recipe', as: 'my_recipe'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :recipes, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
    collection do
      get 'random', to: 'recipes#random', defaults: { format: :js }
    end
  end

  resources :ingredients, only: [:index, :create, :destroy]

  resources :fridges, only: [:show, :update, :create, :new, :edit]

  resources :fridges do
    post 'add_ingredient', on: :member
  end

end
