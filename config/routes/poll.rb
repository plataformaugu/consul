resources :polls, only: [:show, :index] do
  member do
    get :stats
    get :results
    post :answer
    post :participate_manager_existing_user
    post :participate_manager_new_user
    get :pending
  end

  resources :questions, controller: "polls/questions", shallow: true do
    post :answer, on: :member
    resources :answers, controller: "polls/answers", only: :destroy, shallow: false
  end
end

resolve "Poll::Question" do |question, options|
  [:question, options.merge(id: question)]
end
