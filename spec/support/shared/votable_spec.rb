RSpec.shared_examples "votable" do
  let(:user) { create(:user) }

  it 'can be voted up' do
    expect{ resource.voteup(user) }.to change(resource, :rating).from(0).to(1)
  end

  it 'can be voted down' do
    expect{ resource.votedown(user) }.to change(resource, :rating).from(0).to(-1)
  end

  it 'user can take his vote back' do
    resource.voteup(user)
    expect(resource.user_voted?(user)).to eq(true)
    resource.vote_back(user)
    expect(resource.user_voted?(user)).to eq(false)
  end
end