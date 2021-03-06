require 'rails_helper'

feature 'User can add comment to question', %q{
  As authenticated user
  I'd like to leave a comment to a question
} do
  given(:user) { create :user }
  given(:question) { create :question }
  describe "multiple sessions", js: true do
    scenario "comments appear in another browser" do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        within(".question") do
          fill_in "New comment", with: "New question's comment"
          click_on "Add comment"

          expect(page).to have_content "New question's comment"
        end
      end

      Capybara.using_session('guest') do
        within(".question") do
          expect(page).to have_content "New question's comment"
        end
      end
    end
  end
end