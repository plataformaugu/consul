Rails.application.routes.draw do
  resources :popups, :controller => 'admin/popups'
  resources :proposals_themes, :path => 'propuestas'
  resources :encuesta, :path => 'encuestas'
  resources :main_themes, :path => 'ejes-tematicos'
  resources :news do
    collection do
      post :like
      post :dislike
    end
  end
  resources :events do
    collection do
      post :join_to_event
      post :left_event
    end
  end
  get 'admin/users/edit' => 'admin/users#edit_user'
  patch 'admin/users/edit' => 'admin/users#edit_user_patch'

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
  get "/tarjeta-vecino", to: "welcome#tarjeta_vecino"
  get "/welcome", to: "welcome#welcome"
  get "/consul.json", to: "installation#details"
  get 'iniciativas' => 'proposals#initiatives'
  get 'resultados' => 'polls#results_index'
  post 'accounts/update-tarjeta-vecino' => 'users#update_tarjeta_vecino'

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
  resources :pages, path: "/", only: [:show]

  resources :pages do
    post 'send_contact_form', :on => :collection
  end

  post 'accounts/login' => 'users#login'

  delete 'moderation/proposals' => 'moderation/proposals#reject'
  delete 'moderation/debates' => 'moderation/debates#reject'
  delete 'moderation/budget_investments' => 'moderation/budgets/investments#reject'
end
