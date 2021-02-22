require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:award) { create(:award, question: question, recipient: user) }

  before do
    sign_in(user)
    get :index
  end

  describe "GET #index" do
    it "assigns award to @awards" do
      get :index
      expect(assigns(:awards)).to eq user.awards
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end
end
