# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, foreign_key: 'recipient_id', dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :authorizations, dependent: :destroy

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  protected

  def confirmation_required?
    false
  end
end
