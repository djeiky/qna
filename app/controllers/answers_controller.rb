# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :best]

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

  def answers_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
