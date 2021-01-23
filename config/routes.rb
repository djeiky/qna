# frozen_string_literal: true

Rails.application.routes.draw do
  get 'awards/index'
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: [:edit] do
    resources :answers, shallow: true, only: [:create, :update, :destroy, :best] do
      member do
        patch :best
      end
    end
  end

  resources :attachment, only: [:destroy]
  resources :links, only: [:destroy]
  resources :awards, only: [:index]
end
