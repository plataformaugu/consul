resources :comments, only: [:create, :show], shallow: true do
  member do
    post :vote
    put :flag
    put :unflag
    put :hide
    post :validate
    post :custom_hide
  end
end
