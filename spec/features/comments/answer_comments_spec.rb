require 'rails_helper'

feature 'User can add comment to answer', %q{
  As authenticated user
  I'd like to leave a comment to an answer
} do
  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create(:answer, question: question) }
  describe "multiple sessions", js: true do
    scenario "comments appear in another browser" do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        within(".answers") do
          fill_in "New comment", with: "New question's comment"
          click_on "Add comment"

          expect(page).to have_content "New question's comment"
        end
      end

      Capybara.using_session('guest') do
        within(".answers") do
          expect(page).to have_content "New question's comment"
        end
      end
    end
  end
end