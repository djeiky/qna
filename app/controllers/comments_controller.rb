class CommentsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_commentable

  def create
    Rails.logger.debug "OOPPSS"
    Rails.logger.debug @commentable
    Rails.logger.debug "EEENNNDDD"
  end

  private
  def comments_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    commentable_id = params[]
  end
end