require 'rails_helper'

RSpec.describe AttachmentController, type: :controller do
  let(:user) {create(:user)}
  let(:question) {create(:question, :with_file, user: user)}
  let(:answer) {create(:answer, :with_file, question:question, user: user)}

  before {login(user)}

  describe "DELETE #destroy" do
    context 'question' do
      context 'author of a question' do
        it 'delete attachment' do
          expect { delete :destroy, params: {id: question.files.first}, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: {id: question.files.first}, format: :js
          expect(response).to render_template :destroy
        end
      end

    end

    context 'not author of a question' do
      let(:user_two) {create(:user)}

      before {login(user_two)}

      it "not delete attachment" do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.not_to change(question.files, :count)
      end

      it 'returns 403' do
        delete :destroy, params: {id: question.files.first}, format: :js
        expect(response.status).to eq(403)
      end
    end

    context 'answer' do
      context 'author of an answer' do
        it 'delete attachment' do
          expect { delete :destroy, params: {id: answer.files.first}, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: {id: answer.files.first}, format: :js
          expect(response).to render_template :destroy
        end
      end

    end

    context 'not author of an answer' do
      let(:user_two) {create(:user)}

      before {login(user_two)}

      it "not delete attachment" do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.not_to change(answer.files, :count)
      end

      it 'returns 403' do
        delete :destroy, params: {id: answer.files.first}, format: :js
        expect(response.status).to eq(403)
      end
    end
  end

end
