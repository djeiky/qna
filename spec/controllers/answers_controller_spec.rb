# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) {create(:user)}
  let!(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user)}
  let(:another_user) {create(:user)}
  let!(:another_answer) {create(:answer, question: question, user: another_user)}


  describe 'POST #create' do
    before {login(user)}
    context 'with valid params' do
      it 'saves new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end
      it "seves new user's answer to database" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(user.answers, :count).by(1)
      end
      it 'render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end
    context 'with invalid params' do
      it 'not saves invalid answer to datatbase' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end
      it 're-renders answer create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    before {login(user)}
    context "updates own answer with valid attributes" do
      it "change attributes" do
        patch :update, params: {id: answer, answer: {body: "New Body"}}, format: :js
        answer.reload
        expect(answer.body).to eq "New Body"
      end

      it "renders template update" do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
        expect(response).to render_template :update
      end

    end

    context "tries to update with invalid attributes" do
      it "does not change attributes" do
        old_answer_body = answer.body
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        answer.reload
        expect(answer.body).to eq old_answer_body
      end

      it "renders update template" do
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        expect(response).to render_template :update
      end
    end

    context "tries to update sombody's else anser" do
      it "not change answer attributes" do
        patch :update, params: {id: another_answer, answer: {body: "New Answer Body"}}, format: :js
        another_answer.reload
        expect(another_answer.body).to_not eq "New Answer Body"
      end
    end
  end

  describe "PATCH #best" do
    before { login(user) }

    context "User choose best answer for his question" do
      it "sets best answer" do
        patch :best, params: {id: answer}, format: :js
        answer.reload
        expect(answer).to be_best
      end

    end
    context "User choose best answer for sombody's question" do
      it "not change answer to best" do
        sign_in another_user
        patch :best, params: {id: answer}, format: :js
        answer.reload

        expect(answer).to_not be_best
      end
    end
  end

  describe 'DELETE #destroy' do

    before { login(user) }

    it "user deletes own answer" do
      expect {delete :destroy, params: {id: answer}, format: :js}.to change(Answer, :count).by(-1)
    end

    it "user deletes somebody's answer"do
      expect {delete :destroy, params: {id: another_answer}, format: :js}.to_not change(Answer, :count)
    end

    it "render destroy template" do
      delete :destroy, params: {id: answer}, format: :js
      expect(response).to render_template :destroy
    end
  end
end
