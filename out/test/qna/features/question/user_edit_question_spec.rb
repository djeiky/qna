require "rails_helper"

feature "Author can edit his question", %q{
  In order to correct mistakes
  As author of question
  I'd like to be able to edit my question
} do
  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:another_user) {create(:user)}
  given!(:another_question) {create(:question, user: another_user)}

  describe "Authentiacted user" do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario "can edit his question", js: true do
      within ".question" do
        click_on "Edit"

        fill_in "Title", with: "New Question Title"
        fill_in "Body", with: "New Question Body"
        click_on "Update Question"
      end

      expect(page).to_not have_content question.title
      expect(page).to have_content "New Question Title"
      expect(page).to have_content "New Question Body"

    end

    scenario "can't edit somebody's question", js: true do
      visit question_path(another_question)
      within ".question" do
        expect(page).to have_no_link "Edit"
      end
    end

    scenario "edit question with invalid params", js: true do
      within ".question" do
        click_on "Edit"

        fill_in "Title", with: ""
        click_on "Update Question"
      end

      expect(page).to have_content "Title can't be blank"

    end
  end

  scenario "Unauthenticated user can't edit question", js: true do
    visit question_path(question)
    within ".question" do
      expect(page).to have_no_link "Edit"
    end
  end
end
