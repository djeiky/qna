# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
    @question.build_award
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user&.author_of?(@question)
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to question_path, alert: 'You are not author of this question.'
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question = @question
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], award_attributes: [:title, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        question: @question
    )
  end
end
