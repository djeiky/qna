require "rails_helper"

feature "User can delete links to a question", %q{
  In order to provide additional info
  As an question's author
  I'd like to be able to delete links
} do
  given!(:user) { create :user }
  given(:user2) { create :user }
  given!(:question) { create :question, :with_link, user: user }

  scenario "Author of a question delete link", js: true do
    sign_in user
    visit question_path(question)
    within(".question-links") do
      click_on "Delete"

      expect(page).to_not have_content "ya.ru"
    end
  end

  scenario "Not authenticated user tries delete link", js: true do
    sign_in(user2)
    visit question_path(question)

    within(".question-links") do

      expect(page).to_not have_content "Delete"
    end
  end
end