module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voteup(voter)
    set_vote(voter, 1)
  end

  def votedown(voter)
    set_vote(voter, -1)
  end

  def vote_back(voter)
    votes.find_by(user: voter)&.delete
  end

  def rating
    votes.sum(:value)
  end

  def user_voted?(voter)
    votes.exists?(user: voter)
  end

  private

  def set_vote(voter, value)
    #return nil if voter == user

    cur_vote = votes.find_by(user: voter)
    if cur_vote
      cur_vote.update!(value: value)
    else
      votes.create!(value: value, user: voter)
    end
  end
end