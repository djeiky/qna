# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before {login(user)}
    context 'with valid params' do
      it 'saves new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
      it 'redirects to the question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end
    context 'with invalid params' do
      it 'not saves invalid answer to datatbase' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      it 're-renders answer new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) {create(:answer, question: question, user: user)}
    let(:another_user) {create(:user)}
    let!(:another_answer) {create(:answer, question: question, user: another_user)}

    before {login(user)}

    context "user deletes own answer" do
      it "deletes answer" do
        expect {delete :destroy, params: {id: answer}}.to change(Answer, :count).by(-1)
      end

      it "redirect to question show view" do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question_path(question)
      end
    end

    context "user deletes somebody's answer"
  end
end
