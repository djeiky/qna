# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      post :voteup
      post :votedown
      post :vote_back
    end
  end

  resources :questions, concerns: [:voted], except: [:edit] do
    resources :answers, concerns: [:voted], shallow: true, only: [:create, :update, :destroy, :best] do
      member do
        patch :best
      end
    end
  end

  resources :attachment, only: [:destroy]
  resources :links, only: [:destroy]
  resources :awards, only: [:index]
end
