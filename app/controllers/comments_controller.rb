class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new comments_params
    @comment.user = current_user
    @comment.save
    render json: @comment
  end

  private

  def comments_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
    ActionCable.server.broadcast(
        "comments_question_#{question_id}",
        comment: @comment
    )
  end
end