OpenNutritionDatabase::Application.routes.draw do
  resources :foods, :only => [:show]
end
