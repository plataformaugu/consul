resources :polls, only: [:show, :index] do

  collection do
    resources :results, controller: "polls/results", only: [:show, :index]
  end

  resources :questions, controller: "polls/questions", shallow: true do
    post :answer, on: :member
    resources :answers, controller: "polls/answers", only: :destroy, shallow: false
  end
end

resolve "Poll::Question" do |question, options|
  [:question, options.merge(id: question)]
end
