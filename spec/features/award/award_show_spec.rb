require "rails_helper"

feature "Authenticated user can see his awards" do
  let!(:user) { create(:user) }
  let!(:question) {create(:question)}
  let!(:award) {create(:award, :with_image, question: question, recipient: user)}

  scenario "User ee awards list" do
    sign_in user
    visit root_path
    click_on "Awards"

    expect(page).to have_content question.title
    expect(page).to have_content question.award.title
  end
end