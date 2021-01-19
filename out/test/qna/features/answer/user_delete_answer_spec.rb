require "rails_helper"

feature "User delete answer", %q{
  In order to delete answer
  I neet to an author of answer
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given(:another_user) {create(:user)}

  describe "authenticated user" do

    scenario "tries to delete own answer", js: true do
      sign_in user
      visit question_path(question)
      within ".answers" do
        click_on "Delete Answer"
        page.driver.browser.switch_to.alert.accept

        expect(page).to_not have_content answer.body
      end
    end

    scenario "tries to delete sombody's answer" do
      sign_in another_user
      visit question_path(question)

      expect(page).to have_no_link "Delete Answer"
    end
  end
  scenario "Unauthenticated user tries to delete answer" do
    visit question_path(question)

    expect(page).to have_no_link "Delete Answer"
  end
end
