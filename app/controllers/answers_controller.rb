# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answers_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
