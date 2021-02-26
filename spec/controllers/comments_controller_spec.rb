require 'rails_helper'

Rspec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }

  describe "POST #create" do
    before { login user }

    context "with valid attributes" do
      #it "saves new comment ot hte question to database" do
      #  expect {
      #    post :create,
      #         params: {
      #           question_id: question.id,
      #           comment: attributes_for(:comment),
      #           commentable: 'Question'
      #         }, format: :js
      #  }.to change(question.comments, :count).by(1)
      #end

      it "returns comment as a json" do
        post :create,
             params: {
               question_id: question.id,
               comment: attributes_for(:comment),
               commentable: 'Question'
             }, format: :js
        expect(response.body).to be_eq Comment.last.to_json
      end
    end
  end
end