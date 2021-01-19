require "rails_helper"

feature "Author can edit his answer", %q{
  In order to correct mistakes
  As author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given!(:another_user) {create(:user)}

  scenario "Unauthenticated user can't edit answer", js: true do
    visit question_path(question)

    within(".answers") do
      expect(page).to have_no_link("Edit")
    end
  end
  describe "Authenticated user", js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario "edit own answer" do
      within ".answers" do
        click_on "Edit Answer"
        fill_in "Body", with: "Edited answer"
        click_on "Update Answer"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "Edited answer"
        expect(page).to have_no_selector "textarea"
      end
    end
    scenario "edit answer with invalid params" do
      within ".answers" do
        click_on "Edit Answer"
        fill_in "Body", with: ""
        click_on "Update Answer"

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "tries to edit somebody's answer" do
    sign_in another_user
    visit question_path(question)

    within ".answers" do
      expect(page).to have_no_link "Edit Answer"
    end
  end
end
