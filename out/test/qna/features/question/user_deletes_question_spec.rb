require "rails_helper"

feature "User delete question", %q{
  In order to delete question
  As Authenticated user
  I need to be an author of a question
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}
  given(:another_user) {create(:user)}
  given(:another_question) {create(:question, user: another_user)}

  describe "Authenticated user" do
    scenario "tries to delete own question" do
      sign_in user
      visit question_path(question)
      click_on "Delete"

      expect(page).to have_content "Your question successfully deleted."
      expect(current_path).to eq questions_path
    end

    scenario "tries to delete sombody's else question" do
      sign_in user
      visit question_path(another_question)

      expect(page).to have_no_link "Delete"
    end
  end

  scenario "Unauthorized user tries to delete it" do
    visit question_path(question)

    expect(page).to have_no_link "Delete"
  end
end
