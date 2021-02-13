require "rails_helper"

feature "User can delete links to an answer", %q{
  In order to provide additional info
  As an answers's author
  I'd like to be able to delete links
} do
  given!(:user) { create :user }
  given(:user2) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, :with_link, question: question, user: user }

  scenario "Author of an answer delete link", js: true do
    sign_in user
    visit question_path(question)
    within(".answers") do
      click_on "Delete Link"

      expect(page).to_not have_content "ya.ru"
    end
  end

  scenario "Not authenticated user tries delete link", js: true do
    sign_in(user2)
    visit question_path(question)

    within(".answers") do
      expect(page).to_not have_content "Delete Link"
    end
  end
end