# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'oauth_callbacks',
                                   confirmations: 'oauth_confirmations'}
  root to: 'questions#index'

  concern :voted do
    member do
      post :voteup
      post :votedown
      post :vote_back
    end
  end

  #concern :commented do
  #  resources :comments, only: [:create]
  #end

  resources :questions, concerns: [:voted], except: [:edit] do
    resources :comments, module: :questions, only: [:create]
    resources :answers, concerns: [:voted], shallow: true, only: [:create, :update, :destroy, :best] do
      resources :comments, module: :answers, only: [:create]
      member do
        patch :best
      end
    end
  end

  resources :attachment, only: [:destroy]
  resources :links, only: [:destroy]
  resources :awards, only: [:index]

  mount ActionCable.server => "/cable"
end
