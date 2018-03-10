Rails.application.routes.draw do
  
  get 'sessions/new'
  get 'sessions/success'
  post 'sessions' => 'sessions#create'
  delete 'sessions' => 'sessions#destroy'

  resources :users
  root 'welcome#index', as: 'home'
  resources :questions do
    resources :answers
  end


  resources :categories, except: [:destroy]

  resources :answers do
    member do
      put "like" => "answers#upvote"
      put "unlike" => "answers#downvote"
  end
end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
