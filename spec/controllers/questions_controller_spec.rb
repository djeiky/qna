# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_user) { create(:user) }

  describe 'GET #index' do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template(:new)
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new empty award to a question' do
      expect(assigns(:question).award).to be_a_new(Award)
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid params' do
      it 'saves new question to database' do
        expect { post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it "saves new user's question to database" do
        expect { post :create, params: {question: attributes_for(:question)} }.to change(user.questions, :count).by(1)
      end

      let(:question) { create(:question) }
      it 'redirects to show question view' do
        post :create, params: {question: {title: "test title", body: "test body"}}
        new_question = Question.find_by(title: "test title")
        expect(response).to redirect_to new_question
      end
    end
    context 'with invalid params' do
      it 'not to save question to database' do
        expect { post :create, params: {question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid params' do
      it 'changes question attributes' do
        patch :update, params: {id: question, question: {title: 'NewTitle', body: 'NewBody'}, format: :js}
        question.reload

        expect(question.title).to eq 'NewTitle'
        expect(question.body).to eq 'NewBody'
      end
      let!(:another_question) { create(:question, user: another_user) }
      it "not change attributes another user's question" do
        patch :update, params: {id: another_question, question: {title: 'NewTitle', body: 'NewBody'}, format: :js}
        another_question.reload

        expect(question.title).to_not eq 'NewTitle'
        expect(question.body).to_not eq 'NewBody'
      end

      it 'render update question view' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      before { patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js }
      it 'not change question' do
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 're-renders update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question, user: user) }
    let!(:another_question) { create(:question, user: another_user) }

    it 'deletes question from database' do
      expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
    end
    it "tries to delete another user's question" do
      expect { delete :destroy, params: {id: another_question} }.to_not change(Question, :count)
    end

    it 'redirects to question index view' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end
end
