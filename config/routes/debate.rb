resources :debates do
  member do
    post :vote
    put :flag
    put :unflag
    put :mark_featured
    put :unmark_featured
    patch :publish
    patch :toggle_finished
    get :pending
  end

  collection do
    get :suggest
    put "recommendations/disable", only: :index, controller: "debates", action: :disable_recommendations
  end
end
