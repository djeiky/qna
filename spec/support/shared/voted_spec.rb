RSpec.shared_examples "voted" do
  let(:user) { create(:user) }
  context 'authenticated user' do
    before { sign_in(user) }

    context 'vote up resource' do
      it 'change rating' do
        expect{ patch :voteup, params: { id: resource } }.to change(resource, :rating).from(0).to(1)
      end

      it 'render json with id, rating, current_user_voted' do
        patch :voteup, params: { id: resource }
        expect(JSON.parse(response.body)).to eq( {"id" => resource.id, "rating" => 1, "current_user_voted" => true} )
      end
    end

    context 'votedown resource' do
      it 'change rating' do
        expect{ patch :votedown, params: { id: resource } }.to change(resource, :rating).from(0).to(-1)
      end

      it 'render json with id, rating, current_user_voted' do
        patch :votedown, params: { id: resource }
        expect(JSON.parse(response.body)).to eq( {"id" => resource.id, "rating" => -1, "current_user_voted" => true} )
      end
    end

    context 'take his vote back' do
      it 'remove user from voted users' do
        patch :voteup, params: { id: resource }
        expect{ patch :vote_back, params: { id: resource } }.to change{ resource.user_voted?(user) }.from(true).to(false)
      end

      it 'render json with id, rating, current_user_voted' do
        resource.voteup(user)
        patch :vote_back, params: { id: resource }
        expect(JSON.parse(response.body)).to eq( {"id" => resource.id, "rating" => 0, "current_user_voted" => false} )
      end
    end
  end

  context "author can't vote for his resource" do
    before { sign_in(resource.user) }

    it "vote up doesn't change rating" do
      expect{ patch :voteup, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "vote down doesn't change rating" do
      expect{ patch :votedown, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "vote back doesn't change votes" do
      expect{ patch :vote_back, params: { id: resource } }.not_to change(Vote, :count)
    end
  end

  context "guest can't vote for resource" do

    it "vote up doesn't change rating" do
      expect{ patch :voteup, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "vote down doesn't change rating" do
      expect{ patch :votedown, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "vote back doesn't change votes" do
      expect{ patch :vote_back, params: { id: resource } }.not_to change(Vote, :count)
    end
  end
end