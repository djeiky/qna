# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  expose :questions, -> { Question.all }
  expose :question

  def create
    self.question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    if current_user&.author_of?(question)
      if question.update(question_params)
        redirect_to question_path(question)
      else
        render :edit
      end
    else
      redirect_to question_path(question), alert: "You are not author of this question."
    end
  end

  def destroy
    if current_user&.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: "Your question successfully deleted."
    else
      redirect_to question_path, alert: "You are not author of this question."
    end
  end

private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
