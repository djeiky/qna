require "rails_helper"

feature "Author of the question choose best answer", %q{
  As the author of the question
  I can choose best answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario "Author choose best answer", js: true do
    sign_in author
    visit question_path(question)

    within ".answers" do
      click_on "Make Best"

      expect(page).to have_css ".best-answer"
    end
  end

  scenario "Non-Author tries to choose best answer" do
    sign_in user
    visit question_path(question)

    within ".answers" do
      expect(page).to have_no_link "Make Best"
    end
  end

  scenario "Unauthorized user tries to choose best anser" do
    visit question_path(question)
    within ".answers" do
      expect(page).to have_no_link "Make Best"
    end
  end
end
