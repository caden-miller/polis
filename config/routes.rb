# config/routes.rb
Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  resources :users, only: [:show]

  resources :groups

  resources :posts do
    member do
      put 'report'
      post 'upvote'
      post 'downvote'
      post 'verify'
    end
    resources :comments, only: [:create, :destroy] do
      member do
        put 'report', to: 'comments#report', as: 'report'
        post 'upvote', to: 'comments#upvote', as: :upvote
        post 'downvote', to: 'comments#downvote', as: :downvote
      end
    end
  end

  get 'posts/policy_issue/:policy_issue', to: 'posts#policy_issue', as: 'policy_issue_posts'
  
  resources :votes
  resources :facts, only: [:index]
  
  root to: 'home#index'
end
