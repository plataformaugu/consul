Rails.application.routes.draw do
  resources :custom_trackings
  resources :group_users
  mount Ckeditor::Engine => "/ckeditor"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  draw :account
  draw :admin
  draw :annotation
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

  resources :stats, only: [:index]
  resources :images, only: [:destroy]
  resources :documents, only: [:destroy]
  resources :follows, only: [:create, :destroy]
  resources :remote_translations, only: [:create]

  # More info pages
  get "help",             to: "pages#show", id: "help/index",             as: "help"
  get "help/how-to-use",  to: "pages#show", id: "help/how_to_use/index",  as: "how_to_use"
  get "help/faq",         to: "pages#show", id: "faq",                    as: "faq"

  # Static pages
  resources :quizzes, path: 'forms' do
    collection do
      get :monitoring
      post :set_invisible
      post :vote
      post :invite_user
      get :go_prev_quiz
    end
  end
  resources :groups do
    collection do
      post :set_participation
    end
  end

  get "confirm_registration", to: "pages#confirm_registration", id: "confirm_registration", as: "confirm_registration"

  resources :pages, path: "/", only: [:show]
end
