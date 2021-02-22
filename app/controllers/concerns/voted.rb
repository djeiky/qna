module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:voteup, :votedown, :vote_back]
  end

  def voteup
    @resource.voteup(current_user) unless current_user.author_of?(@resource)

    render json: {id: @resource.id, rating: @resource.rating, current_user_voted: true}
  end

  def votedown
    @resource.votedown(current_user) unless current_user.author_of?(@resource)

    render json: {id: @resource.id, rating: @resource.rating, current_user_voted: true}
  end

  def vote_back
    @resource.vote_back(current_user) unless current_user.author_of?(@resource)

    render json: {id: @resource.id, rating: @resource.rating, current_user_voted: false}
  end

  private

  def find_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end