# frozen_string_literal: true

Rails.application.routes.draw do
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
end
