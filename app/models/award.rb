class Award < ApplicationRecord
  belongs_to :question
  belongs_to :recipient, class_name: 'User', optional: true

  validates :title, presence: true

  has_one_attached :image
end
