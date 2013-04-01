OpenNutritionDatabase::Application.routes.draw do
  resources :foods, :only => [:show]

  root :to => 'static#index'
end
