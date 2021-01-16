require "rails_helper"

feature "User create questions", %q{
  In order to get answers
  I'd like to create question
} do

  describe "Authenticated user" do
    given(:user) {create(:user)}

    background do
      sign_in user

      visit root_path
      click_on "Create question"
    end
    scenario "creates question" do
      fill_in "Title", with: "Question title"
      fill_in "Body", with: "Question body"
      click_on "Create"

      expect(page).to have_content "Your question successfully created."
      expect(page).to have_content "Question title"
      expect(page).to have_content "Question body"
    end

    scenario "creates question with invalid params" do
      click_on "Create Question"

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario "Unauthenticated user" do
    visit root_path
    click_on "Create question"
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

end
