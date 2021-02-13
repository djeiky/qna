require "rails_helper"

feature 'User can vote for question', %q{
  In order to determine best question
  As a user
  I'd like to able to vot for questions
} do
  given (:author) { create :user }
  given (:author_question) { create :question, user: author }
  describe "Authenticated user", js: true do
    given (:non_author) { create :user }
    given (:non_author_question) { create :question, user: non_author }

    background do
      sign_in author
      visit question_path(non_author_question)
    end

    scenario "Authenticated user can vote up for a question" do
      within(".question") do
        click_on "Up"

        expect(page).not_to have_link "Up"
        expect(page).to have_link "Vote back"
        expect(page).to have_content "Rating: 1"
      end
    end

    scenario "Authenticated user can vote down for a question" do
      within(".question") do
        click_on "Down"

        expect(page).not_to have_link "Down"
        expect(page).to have_link "Vote back"
        expect(page).to have_content "Rating: -1"
      end
    end

    scenario "Authenticated user can cancel vote for a question" do
      within(".question") do
        non_author_question.voteup(author)
        visit question_path(non_author_question)
        click_on "Vote back"

        expect(page).not_to have_link "Vote back"
        expect(page).to have_link "Up"
        expect(page).to have_link "Down"
        expect(page).to have_content "Rating: 0"
      end
    end

    scenario "Author can't vote for own question" do
      visit question_path(author_question)
      within(".question") do
        expect(page).not_to have_link "Up"
        expect(page).not_to have_link "Down"
        expect(page).not_to have_link "Vote back"
      end
    end
  end

  scenario "Unauthenticated user can't vote" do
    visit question_path(author_question)

    within(".question") do
      expect(page).not_to have_link "Up"
      expect(page).not_to have_link "Down"
      expect(page).not_to have_link "Vote back"
    end
  end
end