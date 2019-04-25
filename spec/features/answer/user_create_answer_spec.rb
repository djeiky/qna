require "rails_helper"

feature "User can create answer for a question", %q{
  In order to answer question
  I need to fill form on question page
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe "Authenticated user" do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "creates answer", js: true do
      within "#new-answer-form" do
        fill_in "Body", with: "New Answer"
        click_on "Create Answer"
      end

      expect(current_path).to eq question_path(question)
      within ".answers" do
        expect(page).to have_content "New Answer"
      end
    end

    scenario "tries to create answer with invalid params", js: true do
      click_on "Create Answer"

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user" do
    visit question_path(question)
    within "#new-answer-form" do
      fill_in "Body", with: "Answer Body"
      click_on "Create Answer"
    end

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
