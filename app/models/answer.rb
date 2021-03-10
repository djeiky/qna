# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :desc, -> { order(best: :DESC) }

  def set_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(recipient: user)
    end
    reload
  end
end
