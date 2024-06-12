resources :users, only: [:show] do
  resources :direct_messages, only: [:new, :create, :show]

  collection do
    get :find_user_by_document_number
  end
end
