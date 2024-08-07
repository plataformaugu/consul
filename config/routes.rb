Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  draw :account
  draw :admin
  draw :budget
  draw :comment
  draw :community
  draw :debate
  draw :devise
  draw :direct_upload
  draw :document
  draw :graphql
  draw :legislation
  draw :management
  draw :moderation
  draw :notification
  draw :officing
  draw :poll
  draw :proposal
  draw :related_content
  draw :sdg
  draw :sdg_management
  draw :tag
  draw :user
  draw :valuation
  draw :verification

  root "welcome#index"
  get "/welcome", to: "welcome#welcome"
  get "/consul.json", to: "installation#details"
  get "robots.txt", to: "robots#index"

  resources :stats, only: [:index]
  resources :images, only: [:destroy]
  resources :documents, only: [:destroy]
  resources :follows, only: [:create, :destroy]
  resources :remote_translations, only: [:create]
  resources :events, only: [:index, :show] do
    member do
      get :participate_manager_form
      post :participate_manager_existing_user
      post :participate_manager_new_user
      post :join
      post :left
      get :pending
    end
  end
  resources :proposal_topics, only: [:index, :show] do
    member do
      get :pending
      get :show, to: 'proposals#index'
    end
  end
  resources :news do
    member do
      get :pending
    end
  end

  resources :surveys do
    member do
      post :send_answers
      post :participate_manager_form
      post :participate_manager_existing_user
      post :participate_manager_new_user
      get :pending
    end
  end
  resources :processes

  # Static pages
  resources :pages, path: "/", only: [:show]
end
