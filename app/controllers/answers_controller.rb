# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :best]

  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    @answer.save
  end

  def best
    @answer.set_best if current_user.author_of?(@answer.question)
    @question = @answer.question
  end

  def update
    if current_user&.author_of?(@answer)
      @answer.update(answers_params)
      @question = @answer.question
    end
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answers_question_#{@question_id}",
      answer: @answer
    )
  end

  def answers_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def set_question
    @question = Question.find(params[:question_id])
    gon.question = @question
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
