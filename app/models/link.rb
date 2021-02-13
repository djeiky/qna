class Link < ApplicationRecord
  URL_FORMAT = /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i
  GIST_FORMAT = /^(https|http):\/\/gist\.github\.com\//i

  belongs_to :linkable, polymorphic: true
  validates :name, presence: true
  validates :url, presence: true, format: {with: URL_FORMAT}

  def gist?
    url =~ GIST_FORMAT
  end
end
